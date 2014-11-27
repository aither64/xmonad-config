import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myTerminal = "konsole"

myManageHook = composeAll
        [ className =? "Firefox"             --> doShift "1"
        , className =? "kate"                --> doShift "2"
        , className =? "jetbrains-rubymine"  --> doShift "2"
        , className =? "Pidgin"              --> doShift "3"
        , className =? "Thunderbird"         --> doShift "4"
        , className =? "gmpc"                --> doShift "5"
        ]

main = do
        xmproc <- spawnPipe "xmobar /home/aither/.xmonad/xmobarrc"
        xmonad $ defaultConfig
                {
                        workspaces = ["1","2","3","4","5","6","7","8","9"]
                        , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
                        , layoutHook = avoidStruts  $  layoutHook defaultConfig
                        , logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "green" "" . shorten 50
                                }
                        , modMask = mod4Mask
                        , terminal = myTerminal
                } `additionalKeys`
                [
                        ((mod4Mask .|. shiftMask, xK_z), spawn "lock")
                        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                        , ((0, xK_Print), spawn "scrot")
                ]


        