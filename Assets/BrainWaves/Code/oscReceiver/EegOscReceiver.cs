﻿using System;
using SharpOSC;

namespace oscReceiver
{
    // event delegates
    public delegate void ActiveFocusUpDelegate(double eventData);
    public delegate void ActiveFocusDownDelegate(double eventData);
    public delegate void BrainExcitementLevelDelegate(double eventData);
    public delegate void AffectionLevelDelegate(double eventData);
    public delegate void VerbalExcitementLevelDelegate(double eventData);
    public delegate void VisualExcitementLevelDelegate(double eventData);
    public delegate void GyroscopeXYDelegate(double eventData);

    public class EegOscReceiver
    {
        public static event ActiveFocusUpDelegate ActiveFocusUpEvent;
        public static event ActiveFocusDownDelegate ActiveFocusDownEvent;
        public static event BrainExcitementLevelDelegate BrainExcitementLevelEvent;
        public static event AffectionLevelDelegate AffectionLevelEvent;
        public static event VerbalExcitementLevelDelegate VerbalExcitementLevelEvent;
        public static event VisualExcitementLevelDelegate VisualExcitementLevelEvent;
        public static event GyroscopeXYDelegate GyroscopeXEvent;
        public static event GyroscopeXYDelegate GyroscopeYEvent;
        // private vars
        private int port;
        private bool isConnected;
        private UDPListener listener;
        // constructor
        public EegOscReceiver(int port)
        {
            this.port = port;
            this.isConnected = false;
        }
        // callback for UDPListener inside StartReceiving
        private HandleOscPacket udpListenerCallback = delegate (OscPacket packet)
        {
            var msg = ((OscBundle)packet);
            for (int i = 0; i < msg.Messages.Count; i++)
            {
                string currentAddress = msg.Messages[i].Address;
                var currentArgument = msg.Messages[i].Arguments[0]; // possible error, assuming only one argument per address.
                double currentDoubleArgument;

                if (!Double.TryParse(currentArgument.ToString(), out currentDoubleArgument))
                {
                    // failed
                    throw new ArgumentException("Expected double got: " + currentArgument.GetType().ToString());
                }
                // Console.WriteLine("callback function called. currentAddress: " + currentAddress + ", currentDoubleArgument: " + currentDoubleArgument);
                switch (currentAddress)
                {
                    case "/up":
                        if (ActiveFocusUpEvent != null)
                            ActiveFocusUpEvent(currentDoubleArgument);
                        break;
                    case "/down":
                        if (ActiveFocusDownEvent != null)
                            ActiveFocusDownEvent(currentDoubleArgument);
                        break;
                    case "/alfa": // excitement weightedAlphaSum
                        if (BrainExcitementLevelEvent != null)
                            BrainExcitementLevelEvent(currentDoubleArgument);
                        break;
                    case "/frontalAlfaAsymetry": // positive reaction
                        if (AffectionLevelEvent != null)
                            AffectionLevelEvent(currentDoubleArgument);
                        break;
                    case "/verbalCenterExcitement":
                        if (VerbalExcitementLevelEvent != null)
                            VerbalExcitementLevelEvent(currentDoubleArgument);
                        break;
                    case "/visualCenterExcitement":
                        if (VisualExcitementLevelEvent != null)
                            VisualExcitementLevelEvent(currentDoubleArgument);
                        break;
                    case "/GYRO-X":
                        if (GyroscopeXEvent != null)
                            GyroscopeXEvent(currentDoubleArgument);
                        break;
                    case "/GYRO-Y":
                        if (GyroscopeYEvent != null)
                            GyroscopeYEvent(currentDoubleArgument);
                        break;
                }
            }
        };

        public void StartReceiving()
        {
            listener = new UDPListener(port, udpListenerCallback);
            isConnected = true;
        }
        public void StopReceiving()
        {
            if (listener != null) listener.Close();
            isConnected = false;
        }
        public bool IsConnected()
        {
            return isConnected;
        }
    };
}
