// This file is part of GameBox. License: GPL3

namespace GameBox
{
    /**
     * The application that manages the GameBox process. Instantiated in the
     * main()-function.
     */
    public class Application : Gtk.Application
    {
        /**
         * Constructs a new GameBox.Application.
         */
        public Application()
        {
            Object(application_id: "gamebox.application",
                   flags:          ApplicationFlags.FLAGS_NONE);
        }

        // Inherited documentation.
        protected override void activate()
        {
            // Don't do anything for now. Just let the application start up and
            // shut down again.
        }
    }
}
