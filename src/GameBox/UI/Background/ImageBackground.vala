namespace GameBox.UI.Background
{
    /**
     * Renders a static image as background.
     */
    public class ImageBackground : Background
    {
        /**
         * Instantiates a new image background without target and image.
         */
        public ImageBackground()
        {
            // 'try' won't catch because passing null to SetImage() does not
            // throw.
            try
            {
                ImageBackground.from_target_and_image(
                    (Gtk.Widget)null, (Gdk.Pixbuf)null);
            }
            catch (IOError ex)
            {}
        }

        /**
         * Instantiates a new image background from target.
         *
         * @param widget The Gtk.Widget to draw on.
         */
        public ImageBackground.from_target(Gtk.Widget widget)
        {
            // 'try' won't catch because passing null to SetImage() does not
            // throw.
            try
            {
                ImageBackground.from_target_and_image(widget, (Gdk.Pixbuf)null);
            }
            catch (IOError ex)
            {}
        }

        /**
         * Instantiates a new image background from image.
         *
         * @param image The image to use as background.
         */
        public ImageBackground.from_image(Gdk.Pixbuf image) throws IOError
        {
            ImageBackground.from_target_and_image((Gtk.Widget)null, image);
        }

        /**
         * Instantiates a new image background.
         *
         * @param widget The Gtk.Widget to draw on.
         * @param image The image to use as background.
         */
        public ImageBackground.from_target_and_image(Gtk.Widget widget,
                                                     Gdk.Pixbuf image)
            throws IOError
        {
            base.from_target(widget);
            this.SetImage(image);
        }

        /**
         * Returns the image used as background.
         *
         * @returns The background image Gdk.Pixbuf.
         */
        public Gdk.Pixbuf GetImage()
        {
            return m_Image;
        }

        /**
         * Sets the image to draw as background.
         *
         * The pixel format of the new image has to match one of the supported
         * ones from ImageSurface. Passing null is allowed, but Draw() will
         * fail then.
         *
         * @param value The new image to draw.
         */
        public void SetImage(Gdk.Pixbuf value) throws IOError
        {
            if (value != null)
            {
                // Determines whether the format is defined or not. Throws
                // exception if not.
                bool known = false;
                Cairo.Format format;

                // Select correct Gdk.Pixbuf format for Cairo.ImageSurface.
                switch (value.colorspace)
                {
                    case Gdk.Colorspace.RGB:
                        if (value.bits_per_sample == 8)
                        {
                            if (value.has_alpha)
                            {
                                format = Cairo.Format.ARGB32;
                                known = true;
                            }
                            else
                            {
                                format = Cairo.Format.RGB24;
                                known = true;
                            }
                        }
                        break;
                }

                if (!known)
                {
                    // Format is unknown, throw exception.
                    throw new IOError.INVALID_DATA(
                        "Unknown pixbuf pixel format.");
                }

                // Set the surface.
                m_Surface = new Cairo.ImageSurface.for_data(
                    value.get_pixels(), Cairo.Format.RGB24,
                    value.width, value.height, value.rowstride);
            }

            // Set the actual property variable.
            m_Image = value;
        }

        // Inherited documentation.
        protected override void Draw(Cairo.Context cr)
        {
            // Save the current context state.
            cr.save();

            // Set the image surface as context source.
            cr.set_source_surface(m_Surface, 0.0, 0.0);
            // Draw the actual image (via a rectangle).
            cr.rectangle(0.0, 0.0, Target.get_allocated_width(),
                Target.get_allocated_height());
            cr.fill();

            // Restore old state.
            cr.restore();
        }

        /**
         * The original Gdk.Pixbuf image to use as background.
         */
        Gdk.Pixbuf m_Image;
        /**
         * The Cairo.ImageSurface generated from Image.
         */
        Cairo.ImageSurface m_Surface;
    }
}

