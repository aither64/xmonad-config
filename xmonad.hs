import XMonad

myTerminal = "konsole"

main = do
        xmonad $ defaultConfig {
	         modMask = mod4Mask,
	         terminal = myTerminal
        }

