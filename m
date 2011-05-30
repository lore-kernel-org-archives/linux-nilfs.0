From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.1.0-rc1 released
Date: Mon, 30 May 2011 12:49:36 +0900 (JST)
Message-ID: <20110530.124936.44132406.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I just released nilfs-utils-2.1.0-rc1 and made it available at:

  http://www.nilfs.org/en/download.html

This release adds two new programs, nilfs-clean, and nilfs-resize.
nilfs-clean is a manual control tool for garbage collector.  It
triggers one pass cleaning on a nilfs partition just by hitting:

  $ sudo nilfs-clean [device]

This tool will also stop/resume/suspend/quit the cleaner when a
corresponding option is specified.

nilfs-resize is online filesystem resize tool.  It can be used to
enlarge or shrink a mounted filesystem located on the device:

  $ sudo nilfs-resize device [size]

This feature is only available on linux-3.0-rc1 at present, which
includes nilfs2 kernel code supporting on-line resizing.

Other changes are as follows:

  * nilfs_cleanerd: allow subsecond values for time interval
    parameters for conffile.
  * lscp: hide internal checkpoints by default and add "--all"
    (or "-a") option to show them.
  * reorganized libraries.
  * fix overflow of time out value
  * fix gc move block errors related to cpfile and sufile
  * etc.

For datails, see the changelog on:

  http://www.nilfs.org/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
