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
            Background.from_target((Gtk.Widget)null);
        }

        /**
         * Instantiates a new Background from Gtk.Widget target.
         *
         * @param widget The Gtk.Widget to draw on.
         */
        protected Background.from_target(Gtk.Widget? widget)
        {
            this.m_Target = null;
            this.Target = widget;
        }

        ~Background()
        {
            ReleaseTarget();
        }

        /**
         * The target widget to draw background from.
         */
        public Gtk.Widget? Target
        {
            get
            {
                return m_Target;
            }
            set
            {
                // Cleanup previous target.
                ReleaseTarget();

                if (value != null)
                {
                    // Connect signals.
                    value.draw.connect(OnDraw);
                    // Save "app_paintable" property for restoring later.
                    m_CachedAppPaintable = value.app_paintable;
                    // Set application paintable to true, so backgrounds do
                    // affect drawing.
                    value.app_paintable = true;
                }

                // Run overridable function hat reacts when the target changed.
                OnTargetChanged(m_Target, value);

                // Set new value.
                m_Target = value;
            }
        }

        private void ReleaseTarget()
        {
            if (Target != null)
            {
                // Disconnect previous signals.
                Target.draw.disconnect(OnDraw);
                // Restore "app_paintable" property.
                Target.app_paintable = m_CachedAppPaintable;
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
        protected virtual void OnTargetChanged(Gtk.Widget? old_widget,
                                               Gtk.Widget? new_widget)
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
        private Gtk.Widget? m_Target;
        private bool m_CachedAppPaintable;
    }
}

