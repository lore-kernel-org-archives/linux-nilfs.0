From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Nilfs2 crash debugging (was: Broken nilfs2 filesystem)
Date: Thu, 15 Aug 2013 12:40:50 +0200
Message-ID: <520CB032.2000602@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se> <51F2A945.6050909@antoneliasson.se> <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9016EBD5-1E01-476F-B1B9-66AE593F4728-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-07-27 18:23:
> Hi Anton,
>
> On Jul 26, 2013, at 8:52 PM, Anton Eliasson wrote:
>
> Thank you for your efforts. But, as I understand, currently, you
> don't reproduce the issue and shared system log doesn't contain
> any new details about the issue. Please, see my description below.
>
[snip]

Hi again. I was able to reproduce the crash on a fully updated system by 
starting the two virtual machines simultaneously as described in my 
e-mail from May 25. I made a new attempt to rebuild the kernel with your 
patches. I selected these options in make menuconfig [1], which resulted 
in this generated config.x86_64 [2] which has the following diff 
compared to the stock config.x86_64:

     --- config.x86_64    2013-08-11 00:06:09.000000000 +0200
     +++ config.x86_64.last    2013-08-11 12:48:44.094979947 +0200
     @@ -1,6 +1,6 @@
      #
      # Automatically generated file; DO NOT EDIT.
     -# Linux/x86 3.10.0-1 Kernel Configuration
     +# Linux/x86 3.10.5-1 Kernel Configuration
      #
      CONFIG_64BIT=y
      CONFIG_X86_64=y
     @@ -5450,6 +5450,11 @@
      # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
      # CONFIG_BTRFS_DEBUG is not set
      CONFIG_NILFS2_FS=m
     +CONFIG_NILFS2_DEBUG=y
     +# CONFIG_NILFS2_USE_PR_DEBUG is not set
     +CONFIG_NILFS2_DEBUG_SHOW_ERRORS=y
     +CONFIG_NILFS2_DEBUG_DUMP_STACK=y
     +# CONFIG_NILFS2_DEBUG_SUBSYSTEMS is not set
      CONFIG_FS_POSIX_ACL=y
      CONFIG_EXPORTFS=y
      CONFIG_FILE_LOCKING=y

I hope those build options are the ones you want. Using the custom 
kernel and mount options, I could reproduce the crash right away. Here's 
the log [3] (crash at timestamp "Aug 15 10:26:26 riven kernel: [  
376.625992]"). The cleaner wasn't running at the time. I don't remember 
if I used the mount option nogc or if I killed it manually after booting up.

Because of these uncertainties and the fact that the log is a bit messy, 
I attempted to rotate the logs, reboot and try again. Of course, that 
caused this heisenbug to disappear again. I produced some pretty logs 
showing lots of errors without the cleaner[4], with the cleaner started 
manually [5] and with the cleaner started at boot [6]. None of them show 
the crash however so they may be of limited use for you.

Okay, one final attempt. I reinstalled the stock kernel and managed to 
crash the system using the virtual machines like before. I then 
reinstalled the custom kernel, rotated the logs, rebooted with the mount 
options "rw,noatime,discard", left the cleanerd running and fired up 
VMware. I was happy to see the system die as expected. [7] and [8] 
should contain beautiful logs of everything from boot to crash.

[1]: http://antoneliasson.se/publicdump/menuconfig.png
[2]: http://antoneliasson.se/publicdump/config.x86_64.last
[3]: http://antoneliasson.se/publicdump/kernel.log.2.gz
[4]: 
http://antoneliasson.se/publicdump/kernel.log.nogc-nocleanerd-nocrash.2013-08-15.1048.log.gz
[5]: 
http://antoneliasson.se/publicdump/kernel.log.nogc-cleanerd-nocrash.2013-08-15.1054.log.gz
[6]: 
http://antoneliasson.se/publicdump/kernel.log.gc-cleanerd-nocrash.2013-08-15.1104.log.gz
[7]: 
http://antoneliasson.se/publicdump/kernel.log.gc-cleanerd-crash.2013-08-15.1205.log.gz
[8]: 
http://antoneliasson.se/publicdump/everything.log.gc-cleanerd-crash.2013-08-15.1211.log.gz

-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
