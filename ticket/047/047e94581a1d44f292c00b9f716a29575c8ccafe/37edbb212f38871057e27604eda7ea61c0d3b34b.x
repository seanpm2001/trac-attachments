Index: src/aui/framemanager.cpp
===================================================================
--- src/aui/framemanager.cpp	���汾 55102��
+++ src/aui/framemanager.cpp	������������
@@ -960,7 +960,7 @@
     if (pinfo.name.empty() || already_exists)
     {
         pinfo.name.Printf(wxT("%08lx%08x%08x%08lx"),
-             ((unsigned long)pinfo.window) & 0xffffffff,
+             ((unsigned long)(intptr_t)pinfo.window) & 0xffffffff,
              (unsigned int)time(NULL),
 #ifdef __WXWINCE__
              (unsigned int)GetTickCount(),
Index: src/common/utilscmn.cpp
===================================================================
--- src/common/utilscmn.cpp	���汾 55102��
+++ src/common/utilscmn.cpp	������������
@@ -817,7 +817,7 @@
 
     ::ShellExecuteEx(&sei);
 
-    const int nResult = (int) sei.hInstApp;
+    const int nResult = (int)(intptr_t) sei.hInstApp;
 
     // Firefox returns file not found for some reason, so make an exception
     // for it
Index: src/msw/dcprint.cpp
===================================================================
--- src/msw/dcprint.cpp	���汾 55102��
+++ src/msw/dcprint.cpp	������������
@@ -319,7 +319,7 @@
     }
 
 
-    HGLOBAL hDevMode = (HGLOBAL)(DWORD) data->GetDevMode();
+    HGLOBAL hDevMode = (HGLOBAL)/*(DWORD)*/(intptr_t) data->GetDevMode();
 
     DEVMODE *lpDevMode = hDevMode ? (DEVMODE *)::GlobalLock(hDevMode) : NULL;
 
Index: src/msw/window.cpp
===================================================================
--- src/msw/window.cpp	���汾 55102��
+++ src/msw/window.cpp	������������
@@ -2592,7 +2592,7 @@
 #ifdef __WXDEBUG__
     wxLogTrace(wxTraceMessages,
                wxT("Processing %s(hWnd=%08lx, wParam=%8lx, lParam=%8lx)"),
-               wxGetMessageName(message), (long)hWnd, (long)wParam, lParam);
+               wxGetMessageName(message), (long)(intptr_t)hWnd, (long)wParam, lParam);
 #endif // __WXDEBUG__
 
     wxWindowMSW *wnd = wxFindWinFromHandle((WXHWND) hWnd);
@@ -3430,7 +3430,7 @@
 
 wxWindow *wxFindWinFromHandle(WXHWND hWnd)
 {
-    return (wxWindow*)wxWinHandleHash->Get((long)hWnd);
+    return (wxWindow*)wxWinHandleHash->Get((intptr_t)hWnd);
 }
 
 void wxAssociateWinWithHandle(HWND hWnd, wxWindowMSW *win)
@@ -3445,19 +3445,19 @@
     if ( oldWin && (oldWin != win) )
     {
         wxLogDebug(wxT("HWND %X already associated with another window (%s)"),
-                   (int) hWnd, win->GetClassInfo()->GetClassName());
+                   (int)(intptr_t) hWnd, win->GetClassInfo()->GetClassName());
     }
     else
 #endif // __WXDEBUG__
     if (!oldWin)
     {
-        wxWinHandleHash->Put((long)hWnd, (wxWindow *)win);
+        wxWinHandleHash->Put((long)(intptr_t)hWnd, (wxWindow *)win);
     }
 }
 
 void wxRemoveHandleAssociation(wxWindowMSW *win)
 {
-    wxWinHandleHash->Delete((long)win->GetHWND());
+    wxWinHandleHash->Delete((long)(intptr_t)win->GetHWND());
 }
 
 // ----------------------------------------------------------------------------
Index: src/msw/toplevel.cpp
===================================================================
--- src/msw/toplevel.cpp	���汾 55102��
+++ src/msw/toplevel.cpp	������������
@@ -1122,7 +1122,7 @@
     {
         // restore focus to the child which was last focused unless we already
         // have it
-        wxLogTrace(_T("focus"), _T("wxTLW %08x activated."), (int) m_hWnd);
+        wxLogTrace(_T("focus"), _T("wxTLW %08x activated."), (int)(intptr_t) m_hWnd);
 
         wxWindow *winFocus = FindFocus();
         if ( !winFocus || wxGetTopLevelParent(winFocus) != this )
@@ -1158,8 +1158,8 @@
 
         wxLogTrace(_T("focus"),
                    _T("wxTLW %08x deactivated, last focused: %08x."),
-                   (int) m_hWnd,
-                   (int) (m_winLastFocused ? GetHwndOf(m_winLastFocused)
+                   (int)(intptr_t) m_hWnd,
+                   (int)(intptr_t) (m_winLastFocused ? GetHwndOf(m_winLastFocused)
                                            : NULL));
 
         event.Skip();
Index: src/msw/menuitem.cpp
===================================================================
--- src/msw/menuitem.cpp	���汾 55102��
+++ src/msw/menuitem.cpp	������������
@@ -188,7 +188,7 @@
 // return the id for calling Win32 API functions
 int wxMenuItem::GetRealId() const
 {
-    return m_subMenu ? (int)m_subMenu->GetHMenu() : GetId();
+    return m_subMenu ? (int)(intptr_t)m_subMenu->GetHMenu() : GetId();
 }
 
 // get item state
Index: src/msw/mdi.cpp
===================================================================
--- src/msw/mdi.cpp	���汾 55102��
+++ src/msw/mdi.cpp	������������
@@ -763,7 +763,7 @@
   wxWindowCreationHook hook(this);
 
   m_hWnd = (WXHWND)::SendMessage(GetWinHwnd(parent->GetClientWindow()),
-                                 WM_MDICREATE, 0, (LONG)(LPSTR)&mcs);
+                                 WM_MDICREATE, 0, (LONG)(intptr_t)(LPSTR)&mcs);
 
   if ( !m_hWnd )
   {
@@ -1433,14 +1433,14 @@
             {
                 success = true;
                 ::InsertMenu(hmenu, i, MF_BYPOSITION | MF_POPUP | MF_STRING,
-                             (UINT)subMenu, _("&Window"));
+                             (UINT)(intptr_t)subMenu, _("&Window"));
                 break;
             }
         }
 
         if ( !success )
         {
-            ::AppendMenu(hmenu, MF_POPUP, (UINT)subMenu, _("&Window"));
+            ::AppendMenu(hmenu, MF_POPUP, (UINT)(intptr_t)subMenu, _("&Window"));
         }
     }
 
Index: src/msw/tooltip.cpp
===================================================================
--- src/msw/tooltip.cpp	���汾 55102��
+++ src/msw/tooltip.cpp	������������
@@ -106,7 +106,7 @@
             uFlags |= TTF_TRANSPARENT;
         }
 
-        uId = (UINT)hwndOwner;
+        uId = (UINT)(intptr_t)hwndOwner;
     }
 };
 
Index: src/msw/menu.cpp
===================================================================
--- src/msw/menu.cpp	���汾 55102��
+++ src/msw/menu.cpp	������������
@@ -377,7 +377,7 @@
 
         submenu->SetParent(this);
 
-        id = (UINT)submenu->GetHMenu();
+        id = (UINT)(intptr_t)submenu->GetHMenu();
 
         flags |= MF_POPUP;
     }
@@ -963,7 +963,7 @@
         for ( i = 0, it = m_menus.begin(); i < count; i++, it++ )
         {
             if ( !::AppendMenu((HMENU)m_hMenu, MF_POPUP | MF_STRING,
-                               (UINT)(*it)->GetHMenu(),
+                               (UINT)(intptr_t)(*it)->GetHMenu(),
                                m_titles[i]) )
             {
                 wxLogLastError(wxT("AppendMenu"));
@@ -1048,7 +1048,7 @@
     {
         // HIBYTE contains the number of items in the submenu in this case
         flagsOld &= 0xff;
-        id = (UINT)::GetSubMenu((HMENU)m_hMenu, mswpos);
+        id = (UINT)(intptr_t)::GetSubMenu((HMENU)m_hMenu, mswpos);
     }
     else
     {
@@ -1124,7 +1124,7 @@
 
         if ( !::InsertMenu(GetHmenu(), (UINT)mswpos,
                            MF_BYPOSITION | MF_POPUP | MF_STRING,
-                           (UINT)GetHmenuOf(menu), title) )
+                           (UINT)(intptr_t)GetHmenuOf(menu), title) )
         {
             wxLogLastError(wxT("InsertMenu"));
         }
@@ -1191,7 +1191,7 @@
 #else
         if ( !::InsertMenu(GetHmenu(), mswpos,
                            MF_BYPOSITION | MF_POPUP | MF_STRING,
-                           (UINT)GetHmenuOf(menu), title) )
+                           (UINT)(intptr_t)GetHmenuOf(menu), title) )
         {
             wxLogLastError(wxT("InsertMenu"));
         }
@@ -1250,7 +1250,7 @@
         }
 #else
         if ( !::AppendMenu(GetHmenu(), MF_POPUP | MF_STRING,
-                           (UINT)submenu, title) )
+                           (UINT)(intptr_t)submenu, title) )
         {
             wxLogLastError(wxT("AppendMenu"));
         }
Index: src/msw/tbar95.cpp
===================================================================
--- src/msw/tbar95.cpp	���汾 55102��
+++ src/msw/tbar95.cpp	������������
@@ -781,8 +781,8 @@
                 TBREPLACEBITMAP replaceBitmap;
                 replaceBitmap.hInstOld = NULL;
                 replaceBitmap.hInstNew = NULL;
-                replaceBitmap.nIDOld = (UINT) oldToolBarBitmap;
-                replaceBitmap.nIDNew = (UINT) hBitmap;
+                replaceBitmap.nIDOld = (UINT)(uintptr_t) oldToolBarBitmap;
+                replaceBitmap.nIDNew = (UINT)(uintptr_t) hBitmap;
                 replaceBitmap.nButtons = nButtons;
                 if ( !::SendMessage(GetHwnd(), TB_REPLACEBITMAP,
                                     0, (LPARAM) &replaceBitmap) )
@@ -811,7 +811,7 @@
         {
             TBADDBITMAP addBitmap;
             addBitmap.hInst = 0;
-            addBitmap.nID = (UINT) hBitmap;
+            addBitmap.nID = (UINT)(uintptr_t) hBitmap;
             if ( ::SendMessage(GetHwnd(), TB_ADDBITMAP,
                                (WPARAM) nButtons, (LPARAM)&addBitmap) == -1 )
             {
@@ -891,7 +891,7 @@
                 {
                     const wxString& label = tool->GetLabel();
                     if ( !label.empty() )
-                        button.iString = (int)label.c_str();
+                        button.iString = (int)(intptr_t)label.c_str();
                 }
 
                 button.idCommand = tool->GetId();
Index: src/msw/thread.cpp
===================================================================
--- src/msw/thread.cpp	���汾 55102��
+++ src/msw/thread.cpp	������������
@@ -527,7 +527,7 @@
             return (THREAD_RETVAL)-1;
         }
 
-        rc = (THREAD_RETVAL)thread->Entry();
+        rc = (THREAD_RETVAL)(intptr_t)thread->Entry();
     }
     wxCATCH_ALL( wxTheApp->OnUnhandledException(); )
 
@@ -847,7 +847,7 @@
             break;
         }
 
-        if ( (DWORD)rc != STILL_ACTIVE )
+        if ( (DWORD)(intptr_t)rc != STILL_ACTIVE )
             break;
 
         // give the other thread some time to terminate, otherwise we may be
@@ -1005,7 +1005,7 @@
     // could we set all bits?
     if ( level != 0 )
     {
-        wxLogDebug(_T("bad level %u in wxThread::SetConcurrency()"), level);
+        wxLogDebug(_T("bad level %u in wxThread::SetConcurrency()"), (int)level);
 
         return false;
     }
@@ -1167,7 +1167,7 @@
     }
 
 #ifdef wxUSE_BEGIN_THREAD
-    _endthreadex((unsigned)status);
+    _endthreadex((unsigned)(intptr_t)status);
 #else // !VC++
     ::ExitThread((DWORD)status);
 #endif // VC++/!VC++
Index: src/msw/textctrl.cpp
===================================================================
--- src/msw/textctrl.cpp	���汾 55102��
+++ src/msw/textctrl.cpp	������������
@@ -960,7 +960,7 @@
     // finally, stream it in the control
     EDITSTREAM eds;
     wxZeroMemory(eds);
-    eds.dwCookie = (DWORD)&wpc;
+    eds.dwCookie = (DWORD)(intptr_t)&wpc;
     // the cast below is needed for broken (very) old mingw32 headers
     eds.pfnCallback = (EDITSTREAMCALLBACK)wxRichEditStreamIn;
 
@@ -1013,7 +1013,7 @@
 
     EDITSTREAM eds;
     wxZeroMemory(eds);
-    eds.dwCookie = (DWORD)&data;
+    eds.dwCookie = (DWORD)(intptr_t)&data;
     eds.pfnCallback = wxRichEditStreamOut;
 
     ::SendMessage
Index: src/msw/frame.cpp
===================================================================
--- src/msw/frame.cpp	���汾 55102��
+++ src/msw/frame.cpp	������������
@@ -851,7 +851,7 @@
             HDC hdc = ::BeginPaint(GetHwnd(), &ps);
 
             // Erase background before painting or we get white background
-            MSWDefWindowProc(WM_ICONERASEBKGND, (WORD)(LONG)ps.hdc, 0L);
+            MSWDefWindowProc(WM_ICONERASEBKGND, (WORD)(LONG)(intptr_t)ps.hdc, 0L);
 
             if ( hIcon )
             {
@@ -1090,7 +1090,7 @@
                 const wxIcon& icon = GetIcon();
                 HICON hIcon = icon.Ok() ? GetHiconOf(icon)
                                         : (HICON)GetDefaultIcon();
-                rc = (long)hIcon;
+                rc = (long)(intptr_t)hIcon;
                 processed = rc != 0;
             }
             break;
Index: src/msw/pen.cpp
===================================================================
--- src/msw/pen.cpp	���汾 55102��
+++ src/msw/pen.cpp	������������
@@ -172,7 +172,7 @@
            case wxSTIPPLE:
                logb.lbStyle = BS_PATTERN ;
                if (M_PENDATA->m_stipple.Ok())
-                   logb.lbHatch = (LONG)M_PENDATA->m_stipple.GetHBITMAP();
+                   logb.lbHatch = (LONG)(intptr_t)M_PENDATA->m_stipple.GetHBITMAP();
                else
                    logb.lbHatch = (LONG)0;
                break;
Index: src/msw/helpwin.cpp
===================================================================
--- src/msw/helpwin.cpp	���汾 55102��
+++ src/msw/helpwin.cpp	������������
@@ -98,7 +98,7 @@
 
     wxString str = GetValidFilename(m_helpFile);
 
-    return (WinHelp(GetSuitableHWND(this), (const wxChar*) str, HELP_PARTIALKEY, (DWORD)(const wxChar*) k) != 0);
+    return (WinHelp(GetSuitableHWND(this), (const wxChar*) str, HELP_PARTIALKEY, (DWORD)(intptr_t)(const wxChar*) k) != 0);
 }
 
 // Can't close the help window explicitly in WinHelp
Index: src/msw/printdlg.cpp
===================================================================
--- src/msw/printdlg.cpp	���汾 55102��
+++ src/msw/printdlg.cpp	������������
@@ -129,10 +129,10 @@
 
 wxWindowsPrintNativeData::~wxWindowsPrintNativeData()
 {
-    HGLOBAL hDevMode = (HGLOBAL)(DWORD) m_devMode;
+    HGLOBAL hDevMode = (HGLOBAL)(intptr_t) m_devMode;
     if ( hDevMode )
         GlobalFree(hDevMode);
-    HGLOBAL hDevNames = (HGLOBAL)(DWORD) m_devNames;
+    HGLOBAL hDevNames = (HGLOBAL)(intptr_t) m_devNames;
     if ( hDevNames )
         GlobalFree(hDevNames);
 }
@@ -144,8 +144,8 @@
 
 bool wxWindowsPrintNativeData::TransferTo( wxPrintData &data )
 {
-    HGLOBAL hDevMode = (HGLOBAL)(DWORD) m_devMode;
-    HGLOBAL hDevNames = (HGLOBAL)(DWORD) m_devNames;
+    HGLOBAL hDevMode = (HGLOBAL)(intptr_t) m_devMode;
+    HGLOBAL hDevNames = (HGLOBAL)(intptr_t) m_devNames;
 
     if (!hDevMode)
     {
@@ -350,8 +350,8 @@
 
 bool wxWindowsPrintNativeData::TransferFrom( const wxPrintData &data )
 {
-    HGLOBAL hDevMode = (HGLOBAL)(DWORD) m_devMode;
-    HGLOBAL hDevNames = (HGLOBAL)(DWORD) m_devNames;
+    HGLOBAL hDevMode = (HGLOBAL)(intptr_t) m_devMode;
+    HGLOBAL hDevNames = (HGLOBAL)(intptr_t) m_devNames;
     if (!hDevMode)
     {
         // Use PRINTDLG as a way of creating a DEVMODE object
@@ -398,7 +398,7 @@
         else
         {
             hDevMode = pd.hDevMode;
-            m_devMode = (void*)(long) hDevMode;
+            m_devMode = (void*)(intptr_t) hDevMode;
             pd.hDevMode = NULL;
 
             // We'll create a new DEVNAMEs structure below.
@@ -568,7 +568,7 @@
     }
 
     // TODO: I hope it's OK to pass some empty strings to DEVNAMES.
-    m_devNames = (void*) (long) wxCreateDevNames(wxEmptyString, data.GetPrinterName(), wxEmptyString);
+    m_devNames = (void*) (intptr_t) wxCreateDevNames(wxEmptyString, data.GetPrinterName(), wxEmptyString);
 
     return true;
 }
@@ -700,13 +700,13 @@
     if (pd->hDevNames)
         GlobalFree(pd->hDevNames);
 
-    pd->hDevMode = (HGLOBAL)(DWORD) native_data->GetDevMode();
+    pd->hDevMode = (HGLOBAL)(intptr_t) native_data->GetDevMode();
     native_data->SetDevMode( (void*) NULL);
 
     // Shouldn't assert; we should be able to test Ok-ness at a higher level
     //wxASSERT_MSG( (pd->hDevMode), wxT("hDevMode must be non-NULL in ConvertToNative!"));
 
-    pd->hDevNames = (HGLOBAL)(DWORD) native_data->GetDevNames();
+    pd->hDevNames = (HGLOBAL)(intptr_t) native_data->GetDevNames();
     native_data->SetDevNames( (void*) NULL);
 
 
@@ -777,9 +777,9 @@
         if (native_data->GetDevMode())
         {
             // Make sure we don't leak memory
-            GlobalFree( (HGLOBAL)(DWORD) native_data->GetDevMode() );
+            GlobalFree( (HGLOBAL)(intptr_t) native_data->GetDevMode() );
         }
-        native_data->SetDevMode( (void*)(long) pd->hDevMode );
+        native_data->SetDevMode( (void*)(intptr_t) pd->hDevMode );
         pd->hDevMode = NULL;
     }
 
@@ -789,9 +789,9 @@
         if (native_data->GetDevNames())
         {
             // Make sure we don't leak memory
-            GlobalFree((HGLOBAL)(DWORD) native_data->GetDevNames());
+            GlobalFree((HGLOBAL)(intptr_t) native_data->GetDevNames());
         }
-        native_data->SetDevNames((void*)(long) pd->hDevNames);
+        native_data->SetDevNames((void*)(intptr_t) pd->hDevNames);
         pd->hDevNames = NULL;
     }
 
