#!/usr/bin/env python
# -*- coding: latin1 -*-

"""Basic frame class, with App for testing."""

__author__ = "Patrick K. O'Brien <pobrien@orbtech.com>"

import wx

class Frame(wx.Frame):
    """Frame class."""

    def __init__(self, parent=None, id=-1, title='Some Title',
                 pos=wx.DefaultPosition, size=(400, 200)):
        """Create a Frame instance."""
        wx.Frame.__init__(self, parent, id, title, pos, size)

	wx.TextCtrl(self,-1,'Title ���' ,style=wx.TE_MULTILINE)
	

class App(wx.App):
    """Application class."""

    def OnInit(self):
        self.frame = Frame()
        self.frame.Show()
        self.SetTopWindow(self.frame)
        return True

def main():
    app = App()
    app.MainLoop()

if __name__ == '__main__':
    main()

 	  	 
