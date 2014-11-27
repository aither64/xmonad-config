import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myTerminal = "konsole"

main = do
        xmonad $ defaultConfig
                {
                        manageHook = manageDocks <+> manageHook defaultConfig
                        , layoutHook = avoidStruts  $  layoutHook defaultConfig
                        , modMask = mod4Mask
                        , terminal = myTerminal
                } `additionalKeys`
                [
                        ((mod4Mask .|. shiftMask, xK_z), spawn "lock")
                        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                        , ((0, xK_Print), spawn "scrot")
                ]


        