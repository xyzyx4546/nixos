import os
import shutil
import argparse
from jinja2 import Template
from material_color_utilities_python import *
from PIL import Image, ImageChops
import random
import glob

HOME_DIR = os.getenv("HOME")
MATERIAL_DIR = f"{HOME_DIR}/.config/material"
TEMPLATES = f"{MATERIAL_DIR}/templates"
COLORS = f"{MATERIAL_DIR}/colors"
WALLPAPER_DIR = f"{MATERIAL_DIR}/wallpapers"
WALLPAPER_PATH = f"{MATERIAL_DIR}/wall.png"

# ================================COLORS=================================================

def get_colors(colorscheme):
  colors = {
    "primary": hexFromArgb(colorscheme.get_primary()),
    "onPrimary": hexFromArgb(colorscheme.get_onPrimary()),
    "primaryContainer": hexFromArgb(colorscheme.get_primaryContainer()),
    "onPrimaryContainer": hexFromArgb(colorscheme.get_onPrimaryContainer()),
    "secondary": hexFromArgb(colorscheme.get_secondary()),
    "onSecondary": hexFromArgb(colorscheme.get_onSecondary()),
    "secondaryContainer": hexFromArgb(colorscheme.get_secondaryContainer()),
    "onSecondaryContainer": hexFromArgb(colorscheme.get_onSecondaryContainer()),
    "tertiary": hexFromArgb(colorscheme.get_tertiary()),
    "onTertiary": hexFromArgb(colorscheme.get_onTertiary()),
    "tertiaryContainer": hexFromArgb(colorscheme.get_tertiaryContainer()),
    "onTertiaryContainer": hexFromArgb(colorscheme.get_onTertiaryContainer()),
    "error": hexFromArgb(colorscheme.get_error()),
    "onError": hexFromArgb(colorscheme.get_onError()),
    "errorContainer": hexFromArgb(colorscheme.get_errorContainer()),
    "onErrorContainer": hexFromArgb(colorscheme.get_onErrorContainer()),
    "background": hexFromArgb(colorscheme.get_background()),
    "onBackground": hexFromArgb(colorscheme.get_onBackground()),
    "surface": hexFromArgb(colorscheme.get_surface()),
    "onSurface": hexFromArgb(colorscheme.get_onSurface()),
    "surfaceVariant": hexFromArgb(colorscheme.get_surfaceVariant()),
    "onSurfaceVariant": hexFromArgb(colorscheme.get_onSurfaceVariant()),
    "outline": hexFromArgb(colorscheme.get_outline()),
    "shadow": hexFromArgb(colorscheme.get_shadow()),
    "inverseSurface": hexFromArgb(colorscheme.get_inverseSurface()),
    "inverseOnSurface": hexFromArgb(colorscheme.get_inverseOnSurface()),
    "inversePrimary": hexFromArgb(colorscheme.get_inversePrimary())
  }
  return colors

def get_colors_from_img(image):
  img = Image.open(image)
  basewidth = 64
  wpercent = (basewidth/float(img.size[0]))
  hsize = int((float(img.size[1])*float(wpercent)))
  img = img.resize((basewidth,hsize),Image.Resampling.LANCZOS)
  theme = themeFromImage(img)
  colorscheme = theme.get('schemes').get('dark')

  colors = get_colors(colorscheme)
  return colors

# ================================GENERAL OPERATIONS=================================================

def render_templates(colors_list):
  if not os.path.exists(COLORS):
    os.makedirs(COLORS)
  for template in os.listdir(TEMPLATES):
    print(f"Rendering {template}")
    with open(f"{TEMPLATES}/{template}", "r") as file:
      template_rendered = Template(file.read()).render(colors_list)
    with open(f"{COLORS}/{template}", "w") as output_file:
      output_file.write(template_rendered)

def setup(img):
  try:
    shutil.copyfile(img, WALLPAPER_PATH)
  except shutil.SameFileError:
    pass
  os.system("pkill -SIGUSR1 kitty")
  os.system(f"ags -r \"(await import('file://$HOME/.config/ags/applyCss.js')).default()\"")
  os.system(f"swww img {WALLPAPER_PATH} --transition-fps 75 --transition-type wipe --transition-duration 2")

# ================================CLI=================================================

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Generate material colors on fly")
  parser.add_argument("IMAGE", help="Specify 'select', 'random', or provide an image file path.")
  IMAGE = parser.parse_args().IMAGE

  if IMAGE == "random":
    while True:
      IMAGE = random.choice(glob.glob(f"{WALLPAPER_DIR}/*"))
      IMAGE_OLD = Image.open(IMAGE)
      IMAGE_NEW = Image.open(WALLPAPER_PATH).resize(IMAGE_OLD.size).convert(IMAGE_OLD.mode)

      if ImageChops.difference(IMAGE_OLD, IMAGE_NEW).getbbox():
          break
  
  elif IMAGE == "select":
    IMAGE = os.popen(f"zenity --file-selection --filename {WALLPAPER_DIR}/*").read().strip()
  
  if os.path.isfile(IMAGE):
    colors = get_colors_from_img(IMAGE)
    render_templates(colors)
    setup(IMAGE)
