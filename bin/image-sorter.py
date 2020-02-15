from piexif._exceptions import InvalidImageDataError
import piexif

import datetime
import hashlib
import logging
import os
import platform
import re
import shutil
import sys

_dates_names = [
    # b'2016:10:18 14:22:51'
    ("0th", "DateTime"),
    ("1st", "DateTime"),
    ("Exif", "DateTimeOriginal"),
    ("Exif", "DateTimeDigitized"),
]

def get_tags_by_names(names):
    tags = []
    for category, name in names:
        for tag, params in piexif.TAGS[category].items():
            if params["name"] == name:
                tags.append((
                    category,
                    name,
                    tag
                ))
                break
    return tags

_dates_tags = get_tags_by_names(_dates_names)

def file_creation_date(path_to_file):
    """
    Try to get the date that a file was created, falling back to when it was
    last modified if that isn't possible.
    See http://stackoverflow.com/a/39501288/1709587 for explanation.
    """
    if platform.system() == 'Windows':
        return os.path.getctime(path_to_file)
    else:
        stat = os.stat(path_to_file)
    try:
        return datetime.datetime.fromtimestamp(stat.st_birthtime)
    except AttributeError:
        # We're probably on Linux. No easy way to get creation dates here,
        # so we'll settle for when its content was last modified.
        return datetime.datetime.fromtimestamp(stat.st_mtime)

dd_mm_yyyy_re = re.compile("([0123]\d)[:,.;-_]([01]\d)[:,.;-_]([12][09]\d\d)")
yyyy_mm_d_re = re.compile("([12][09]\d\d)[:,.;-_]([01]\d)[:,.;-_]([0123]\d)")
dd_mm_yy_re = re.compile("([0123]\d)[:,.;-_]([01]\d)[:,.;-_](\d\d)")
yyyy_re = re.compile("(20|19)(\d\d)")

def guess_date_from_str(s):
    r = dd_mm_yyyy_re.search(s)
    if r is not None:
        d = r.group(1)
        m = r.group(2)
        y = r.group(3)
        try:
            dt = datetime.datetime(year=int(y), month=int(m), day=int(d))
            return dt
        except ValueError:
            pass
    r = yyyy_mm_d_re.search(s)
    if r is not None:
        y = r.group(1)
        m = r.group(2)
        d = r.group(3)
        try:
            dt = datetime.datetime(year=int(y), month=int(m), day=int(d))
            return dt
        except ValueError:
            pass
    r = dd_mm_yy_re.search(s)
    if r is not None:
        d = r.group(1)
        m = r.group(2)
        y = r.group(3)
        try:
            dt = datetime.datetime(year=int(y) + 2000, month=int(m), day=int(d))
            return dt
        except ValueError:
            pass
    r = yyyy_re.search(s)
    if r is not None:
        y = r.group()
        try:
            dt = datetime.datetime(year=int(y), month=1, day=1)
            return dt
        except ValueError:
            pass
    return None


def guess_create_time(file_path):
    # b'2016:10:18 14:22:51'
    # 0th 306 DateTime
    # 1th 306 DateTime
    # Exif 36867 DateTimeOriginal
    # Exif 36868 DateTimeDigitized
    # GPS GPSDateStamp
    dates = []
    try:
        exif_dict = piexif.load(file_path)
        for category, name, tag in _dates_tags:
            value = exif_dict[category].get(tag)
            if value is not None:
                try:
                    d = datetime.datetime.strptime(value.decode("ascii"), "%Y:%m:%d %H:%M:%S")
                    dates.append(d)
                except ValueError as e:
                    logging.warning("Unexpected date format {!r} in file {!r}".format(value.decode("utf-8"), file_path))
    except InvalidImageDataError as e:
        logging.warning("Not an image {!r}".format(e))
    except Exception as e:
        logging.warning("Exif extraction error {!r}".format(e))
    if not dates:
        basename = os.path.basename(file_path)
        d = guess_date_from_str(basename)
        if d is not None:
            logging.warning("Took date {!r} from filename {!r}".format(d, basename))
            dates.append(d)
        else:
            d = guess_date_from_str(file_path)
            if d is not None:
                logging.warning("Took date {!r} from filename {!r}".format(d, file_path))
                dates.append(d)
    if not dates:
        d = file_creation_date(file_path)
        logging.warning("Took date {!r} from filesystem for file {!r}".format(d, file_path))
        dates.append(d)
    return min(dates)


def walk(src_dir, dst_dir):
    for root, subdirs, files in os.walk(src_dir):
        for subdir in subdirs:
            walk(os.path.join(root, subdir), dst_dir)

        for filename in files:
            file_path = os.path.join(root, filename)
            process_file(file_path, dst_dir)


def pick_up_filename(dir_path, basename, keep_unique):
    if basename.startswith("."):
        basename = basename[1:]
    if basename.startswith("~"):
        basename = basename[1:]
    basename = basename.replace("  ", " ").replace("  ", " ").replace("  ", " ")
    basename = basename.replace(" ", "-")
    new_file_name = os.path.join(dir_path, basename)
    if keep_unique and os.path.exists(new_file_name):
        num = 0
        bare_basename, ext = os.path.splitext(basename)
        while os.path.exists(new_file_name):
            num = num + 1
            new_file_name = os.path.join(
                dir_path,
                "{}-{}{}".format(bare_basename, str(num), ext)
            )
    return new_file_name

_md5_cache = {}

def md5(fname, use_cache=False):
    hash_md5 = hashlib.md5()
    if fname not in _md5_cache:
        with open(fname, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_md5.update(chunk)
        if not use_cache:
            return hash_md5.hexdigest()
        _md5_cache[fname] = hash_md5.hexdigest()
    return _md5_cache[fname]

def process_file(file_path, dst_dir):
    bdate = guess_create_time(file_path)
    dst_dir = os.path.join(dst_dir, bdate.strftime("%Y/%b/%d-%a"))
    os.makedirs(dst_dir, exist_ok=True)
    basename = os.path.basename(file_path)
    new_file_name = pick_up_filename(dst_dir, basename, False)
    if os.path.exists(new_file_name):
        if md5(new_file_name, True) == md5(file_path):
            logging.warning("skip repeating file: {} -> {}".format(file_path, new_file_name))
            return
        else:
            new_file_name = pick_up_filename(dst_dir, basename, True)
    logging.info("copy: {} {}".format(file_path, new_file_name))
    shutil.copyfile(file_path, new_file_name)

src_dir = sys.argv[1]
dst_dir = sys.argv[2]

logging.warning("Src {}".format(src_dir))
logging.warning("Dst {}".format(dst_dir))

walk(src_dir, dst_dir)
