// This file is part of GameBox. License: GPL3

namespace GameBox.UI
{
    /**
     * The main application window of GameBox.
     */
    [GtkTemplate (ui = "/GameBox/UI/ApplicationWindow.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow
    {
        /**
         * Instantiates a new GameBox application window.
         *
         * @param application The Gtk.Application to initialize with.
         */
        public ApplicationWindow(Gtk.Application application)
        {
            Object(application: application);

            // Initialize fields.
            this.set_default_size(400, 400);
            this.title = "GameBox";
        }

        /**
         * The main widget that is displayed in this window.
         */
        public Gtk.Widget MainWidget
        {
            get
            {
                return m_ReferenceOverlay.get_child();
            }
            set
            {
                m_ReferenceOverlay.add(value);
            }
        }

        // TODO: Implement notification mechanisms that use the Gtk.Overlay.
        /**
         * Reference to the Gtk.Overlay to display notifications etc.
         */
        [GtkChild (name = "Overlay")]
        private Gtk.Overlay m_ReferenceOverlay;
    }
}
