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
            ImageBackground.from_target_and_image(
                (Gtk.Widget)null, (Gdk.Pixbuf)null);
        }

        /**
         * Instantiates a new image background from target.
         *
         * @param widget The Gtk.Widget to draw on.
         */
        public ImageBackground.from_target(Gtk.Widget? widget)
        {
            ImageBackground.from_target_and_image(widget, (Gdk.Pixbuf)null);
        }

        /**
         * Instantiates a new image background from image.
         *
         * @param image The image to use as background.
         */
        public ImageBackground.from_image(Gdk.Pixbuf? image)
        {
            ImageBackground.from_target_and_image((Gtk.Widget)null, image);
        }

        /**
         * Instantiates a new image background.
         *
         * @param widget The Gtk.Widget to draw on.
         * @param image The image to use as background.
         */
        public ImageBackground.from_target_and_image(Gtk.Widget? widget,
                                                     Gdk.Pixbuf? image)
        {
            base.from_target(widget);
            this.Image = image;
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
         * The image to draw as background.
         *
         * Passing null is allowed, but Draw() may fail then.
         */
        public Gdk.Pixbuf? Image
        {
            get
            {
                return m_Image;
            }
            set
            {
                if (value != null)
                {
                    // Set the surface.
                    m_Surface = Gdk.cairo_surface_create_from_pixbuf(
                        value, 1, Target.get_window());
                }

                // Set the actual property variable.
                m_Image = value;
            }
        }

        // Inherited documentation.
        protected override void Draw(Cairo.Context cr)
        {
            // Saving and restoring of Cairo.Context is not needed here since
            // the widget does that automatically.

            // Set the image surface as context source.
            cr.set_source_surface(m_Surface, 0.0, 0.0);

            // Use invalidate clipping regions to make drawing faster.
            foreach (var rect in cr.copy_clip_rectangle_list().rectangles)
            {
                // Draw the actual image via new rectangles.
                cr.rectangle(rect.x, rect.y, rect.width, rect.height);
            }

            // Fill the rectangles.
            cr.fill();
        }

        /**
         * The original Gdk.Pixbuf image to use as background.
         */
        private Gdk.Pixbuf m_Image;
        /**
         * The Cairo.ImageSurface generated from Image.
         */
        private Cairo.Surface m_Surface;
    }
}

