From: "Martin, Nick" <nickm-gdz6ECn1J1HQT0dZR+AlfA@public.gmane.org>
Subject: CentOS 5 support for nilfs
Date: Sat, 26 Jun 2010 02:10:17 -0500
Message-ID: <A94BFDB17DC4E1478F7ACF6EBA3FD8234AE3F6E52D@p3saturn.p3corpnet.pivot3.com>
References: <1277393260-19835-1-git-send-email-jir@unicus.jp>
	<1277393260-19835-3-git-send-email-jir@unicus.jp>
	<20100625.180639.160014063.ryusuke@osrg.net> <87zkyi1izo.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zkyi1izo.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,		

I have been watching the list and web site for some time, hoping for an update to the CentOS 5 download.
It does not yet include the utilities released on 10 April.

I have a 2.0 TB nilfs file system allocated on an iSCSI SAN volume with about 1.5 TB used.  
It holds about 1.3 million current files and lots of snapshots.  It is being accessed using CentOS 5 (x86_64).
I have preserved daily snapshots since February.  The nilfs file system is working about as expected.
I cannot attribute any crashes or data loss to nilfs.

Although there is no shortage of available free space, the nilfs cleaner produces 400 to 800 IOPS all day long to this iSCSI SAN volume.
I would really appreciate the feature that the cleaner goes to sleep when there is no free space shortage.
This would lighten the load on the iSCSI SAN and leave more bandwidth for other SAN volumes.

I attempted to build the utilities myself from source on CentOS 5, but was not successful.
There seemed to be dependencies I could not resolve.
Can someone post the directions and dependencies to allow me to build it myself?
Alternatively, please let me know when such a build is likely to appear on the downloads page.

I manage the shared file servers for a group of about 20 developers building software that runs on Linux.
Despite the warning messages, I am using nilfs in a production environment as an archival/backup mechanism.
It is far superior to my previous solution which used symbolic links to create daily snapshots without duplicating unchanged files.
I am doing weekly full backups to tape as well, but the efficiency of nilfs allowed me to effectively keep a daily full backup on disk for every day for 4 months. I am now trimming snapshots older than two months down to 2 per month to delay running out of space.  

The next unreleased feature I anticipate needing is the ability to expand a nilfs file system.  
I would now increase my nilfs file system to 3 TB if I could.

Thanks to all who contribute to this useful, and in my experience stable project.
 
Thank you in advance for any help getting current utilities for CentOS. 

I would like to contribute to your project in some way.  
I have some ideas of how I might be able to help.  
I would be happy to explore this offline with someone.

Nick Martin

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
