namespace GameBox
{
    public class Application : Gtk.Application
    {
        /**
         * Constructs a new GameBox application.
         */
        public Application()
        {
            Object(application_id: "gamebox.application",
                   flags:          ApplicationFlags.FLAGS_NONE);
        }

        // Inherited documentation.
        protected override void activate()
        {
            // Initialize resources.
            try
            {
                GameBox.Resources.Initialize();
            }
            catch (Error ex)
            {
                stderr.printf(ex.message + "\n");
                return;
            }

            // Create the window of this application and show it.
            GameBox.UI.ApplicationWindow window =
                new GameBox.UI.ApplicationWindow(this);

            // Show application window.
            window.show_all();
        }
    }
}

