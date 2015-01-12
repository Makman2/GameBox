namespace GameBox.UI.Background
{
    /**
     * The base class for custom window backgrounds.
     */
    public abstract class Background
    {
        /**
         * Instantiates a new Background without target.
         */
        protected Background()
        {
            this.Target = null;
        }

        /**
         * Instantiates a new Background from Gtk.Widget target.
         *
         * @param widget The Gtk.Widget to draw on.
         */
        protected Background.from_target(Gtk.Widget widget)
        {
            this.Target = widget;
        }

        ~Background()
        {
            // Disconnect signals.
            if (Target != null)
            {
                Target.draw.disconnect(OnDraw);
            }
        }

        /**
         * The target widget to draw background from.
         */
        public Gtk.Widget Target
        {
            get
            {
                return m_Target;
            }
            set
            {
                if (m_Target != null)
                {
                    // Disconnect previous signals.
                    m_Target.draw.disconnect(OnDraw);
                }

                if (value != null)
                {
                    // Connect signals.
                    value.draw.connect(OnDraw);
                }

                // Run overridable function hat reacts when the target changed.
                OnTargetChanged(m_Target, value);

                // Set new value.
                m_Target = value;
            }
        }

        /**
         * Invoked when Target changed.
         *
         * Implementation note: Do not access property Target in this function
         * since the update to this value could be incomplete. Use the
         * parameters instead!
         *
         * @param old_widget The old widget before Target was changed.
         * @param new_widget The new widget after Target was changed.
         */
        protected virtual void OnTargetChanged(Gtk.Widget old_widget,
                                               Gtk.Widget new_widget)
        {}

        /**
         * Draws the background. Override this method in derived classes.
         *
         * @param cr The Cairo context to draw on.
         */
        protected abstract void Draw(Cairo.Context cr);

        /**
         * Invoked when widget needs redraw.
         *
         * @param cr The Cairo.Context to draw on.
         * @returns  Everytime false, means other handlers for the target
         *           Gtk.Widget aren't prevented from being invoked.
         */
        private bool OnDraw(Cairo.Context cr)
        {
            Draw(cr);
            return false;
        }

        /**
         * The target widget to draw background from.
         */
        private Gtk.Widget m_Target;
    }
}

