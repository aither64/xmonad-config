import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import System.IO
import System.Exit
import qualified Data.Map        as M

myTerminal = "konsole"
myScrotFile = "'/home/aither/pictures/screenshots/%Y-%m-%d--%H-%M-%S_$wx$h.png'"

myManageHook = composeAll
        [ className =? "Firefox"             --> doShift "1"
        , className =? "kate"                --> doShift "2"
        , className =? "jetbrains-rubymine"  --> doShift "2"
        , className =? "Pidgin"              --> doShift "3"
        , className =? "Thunderbird"         --> doShift "4"
        , className =? "gmpc"                --> doShift "5"
        , isFullscreen                       --> doFullFloat
        ]

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "xmobar /home/aither/.xmonad/xmobarrc"

myPP = defaultPP
        { ppTitle = xmobarColor "#02a2ff" "" . shorten 50
        }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myConfig = defaultConfig
        { workspaces = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]
        , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = smartBorders . avoidStruts  $  layoutHook defaultConfig
        , modMask = mod4Mask
        , terminal = myTerminal
        , keys = myKeys
        }
    
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
         -- launch a terminal
        [ ((modm,          xK_Return     ), spawn $ XMonad.terminal conf)
        
        -- launch a file manager
        , ((modm .|. shiftMask, xK_Return), spawn $ (XMonad.terminal conf) ++ " -e ranger")

        -- launch dmenu
        , ((modm,               xK_p     ), spawn "dmenu_run")

        -- close focused window
        , ((modm .|. shiftMask, xK_c     ), kill)

        -- Rotate through the available layout algorithms
        , ((modm,               xK_space ), sendMessage NextLayout)

        --  Reset the layouts on the current workspace to default
        , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

        -- Resize viewed windows to the correct size
        , ((modm,               xK_n     ), refresh)

        -- Move focus to the next window
        , ((modm,               xK_Tab   ), windows W.focusDown)

        -- Move focus to the next window
        , ((modm,               xK_j     ), windows W.focusDown)

        -- Move focus to the previous window
        , ((modm,               xK_k     ), windows W.focusUp  )

        -- Move focus to the master window
        , ((modm,               xK_m     ), windows W.focusMaster  )

        -- Swap the focused window and the master window
--         , ((modm,               xK_Return), windows W.swapMaster)

        -- Swap the focused window with the next window
        , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

        -- Swap the focused window with the previous window
        , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

        -- Shrink the master area
        , ((modm,               xK_h     ), sendMessage Shrink)

        -- Expand the master area
        , ((modm,               xK_l     ), sendMessage Expand)

        -- Push window back into tiling
        , ((modm,               xK_t     ), withFocused $ windows . W.sink)

        -- Increment the number of windows in the master area
        , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

        -- Deincrement the number of windows in the master area
        , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

        -- Toggle the status bar gap
        -- Use this binding with avoidStruts from Hooks.ManageDocks.
        -- See also the statusBar function from Hooks.DynamicLog.
        --
        -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

        -- Quit xmonad
        , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
        
        -- Restart xmonad
        , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

        -- Run xmessage with a summary of the default keybindings (useful for beginners)
        --, ((modMask .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
        
        -- Lock the desktop
        , ((mod1Mask .|. controlMask, xK_l), spawn "lock")
        
        -- Screenshots
        -- Select window to capture
        , ((controlMask, xK_Print), spawn ("sleep 0.2; scrot -s " ++ myScrotFile))
        
        -- Screenshot whole screen
        , ((0, xK_Print), spawn ("scrot " ++ myScrotFile))
        ]
        ++

        --
        -- mod-[1..9], Switch to workspace N
        -- mod-shift-[1..9], Move client to workspace N
        --
        [((m .|. modm, k), windows $ f i)
                | (i, k) <- zip (XMonad.workspaces conf) [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace]
                , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        ++

        --
        -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
        --
        [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
                | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
                , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

        