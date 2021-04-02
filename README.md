# Haunted Picture Frame

Source code for a raspberry pi zero to drive an eink display for
HILARIOUS JAPES.

## Installation

Check out this repo somewhere handy. I put it in `~/cam`. You may wish
to put it somewhere else.

### Packages to install

    $ sudo apt install ruby-sinatra

### System prep

Raspberry Pi OS, for some reason, doesn't put `/tmp` in a `tmpfs`.  This
seems weird, but I'm sure they've got their reasons.  Anyway, this app
wants somewhere to stash the photos that it takes.  It doesn't need to
keep them, it just needs a scratch space: `/tmp` is fine for that.  Also
I've been trying to find the quickest way to get a photo out of
`raspistill` and removing the need to write to the SD card seems like a
very good plan.

Add the following to `/etc/fstab`:

    tmpfs /tmp tmpfs defaults,noatime,nosuid 0 0

You may also wish to add this:

    tmpfs /var/log tmpfs defaults,noatime,nosuid,size=16m 0 0

That moves the system logs out to RAM.  Adding `commit=600` to the ext4
`/` entry is probably a good idea too: this alters the settings so that
the root filesystem is only flushed to the SD card once every 10 minutes
rather than once every 5 seconds. Note if you do this that it is MUCH
MORE IMPORTANT that you shut down the zero properly rather than pulling
the power. You're much more likely to end up with a broken system if you
don't.

Reboot after making these changes.

### Setting up the image link

Eventually this will be automatic, but for now you need to make a
symlink from the `public` directory to the file that `raspistill` will
generate in your `/tmp` directory. Run the following:

    ln -s /tmp/image.jpeg public/image.jpeg

It doesn't matter if `/tmp/image.jpeg` doesn't exist yet.

## Running the app

The simplest way to run the app is in a `tmux` or `screen` session.

To launch the app:

    $ ruby app.rb


## What it's doing

The app listens on port 4567. Connect at
http://<your-pi-hostname>:4567/.  It runs a `raspistill` process in the
background which it signals each time an image is requested. This avoids
the warmup time the camera would otherwise need at each invocation.

To request an image, click the `Take a picture` button.

## Other notable notes

To this app will, in future, be added the ability to upload an image to
be displayed. My display hasn't arrived yet, though, so I've not done
that bit yet.

## Author

Alex Young <alex@blackkettle.org>
