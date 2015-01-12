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
        public ImageBackground.from_target(Gtk.Widget widget)
        {
            ImageBackground.from_target_and_image(widget, (Gdk.Pixbuf)null);
        }

        /**
         * Instantiates a new image background from image.
         *
         * @param image The image to use as background.
         */
        public ImageBackground.from_image(Gdk.Pixbuf image)
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
        {
            base.from_target(widget);
            this.Image = image;
        }

        /**
         * The image to draw.
         */
        public Gdk.Pixbuf Image
        { get; set; }

        // Inherited documentation.
        protected override void Draw(Cairo.Context cr)
        {
            // Save the current context state.
            cr.save();

            // Create png-stream from resource.
            // ###
            // Feed the Cairo.ImageSurface with it.
            // ###
            // Set the image surface as context source.
            // ###
            // Draw the actual image (via a rectangle).
            // ###

            // Restore old state.
            cr.restore();
        }
    }
}

