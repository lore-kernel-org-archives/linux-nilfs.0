From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: RE: 'nilfs' TRIM issue?
Date: Thu, 06 Sep 2012 10:25:06 +0400
Message-ID: <1346912706.2083.23.camel@slavad-ubuntu-11>
References: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835B3@Etamin.tachyon.net>
	 <1346826651.2096.9.camel@slavad-ubuntu-11>
	 <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835DE@Etamin.tachyon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=bW46pn1bM6d5wKxNaRl17WxKD3vX3i7XM1BsJYBnWYY=;
	b=M8YFhUyeErtARlKYuO+m1R9riUPakSk1NttkCFLElypywcDplk05h9jZfhSFXBwWP3N5wcSGxQgsjQ6X2w83miZ/LU6F1BnS8fa2vXBB1Yy04RqlgCNX0ho0XOJVirHT;
In-Reply-To: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835DE-Nr8giE/DiON166AYIJghu6xOck334EZe@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Cc: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Rodriguez <Eric.Rodriguez-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>

Hi Mark,

On Wed, 2012-09-05 at 13:52 -0700, Mark Trumpold wrote:
> Hello Vyacheslav,
> 
> > Do you use NILFS as root file system?
> >
> Actually, 'nilfs' on this system is just a container that contains loop
> images, one of which is the root filesystem.  As you can see this is
> a little out of the norm, so I think I should do more homework before
> involving a lot of your time..  At this point it in not clear if TRIM is
> working at all for 'ext4' or 'nilfs' on our system.  It may be that the
> warning from 'nilfs' is legitimate.
> 
> I think it might be best for me to first find a way to test whether or
> not TRIM is working in general for a particular configuration.
> I've gone to a totally generic system with just a test 'nilfs' and 'ext4'
> partition to get some experience.  One thing I've noticed is 'ext4' does
> not complain if you mount with 'discard' on a device that does NOT
> support it -- so that's no help.
> 
> I've tried the following simple sequence:
> dd if=/dev/urandom of=tempfile bs=1M count=3
> hdparm --fibmap tempfile    <-- get start address of the file
> hdparm --read-sector [ADDRESS] /dev/sda
> rm tempfile && sync && sleep 120
> hdparm --read-sector [ADDRESS] /dev/sda   <-- should be all zero's
> 

Maybe I misunderstand something, but why do you expect zero's in sector
at the end?

Even in the case of discard support by filesystem and TRIM support by
device it is not so easy to predict the moment of time when operation of
real erasing will be occurred. As I understand, for example, MMC
specification declares that real erase occurs in background after TRIM
command receiving. And erase can be made under erase block instead of
sector.

Moreover, in the case of NILFS deletion of file means that will be
created next checkpoint that will keep new metadata state. And deleted
file continues to be kept in previous checkpoint. During a some time
this checkpoint can be deleted also but it can be significant time
duration. So, your trying to read sector by absolute address results in
reading not zeros.

As I can see from man page of hdparm, it exists --trim-sector-ranges
option:

"For  Solid State Drives (SSDs).  EXCEPTIONALLY DANGEROUS. DO NOT USE
THIS FLAG!!  Tells the drive firmware to discard unneeded data sectors,
destroying any data that may have been present within them.  This makes
those sectors available for immediate use by the firmware's garbage
collection mechanism, to improve scheduling for wear-leveling of the
flash media.  This option expects one or more sector range pairs
immediately after  the flag: an LBA starting address, a colon, and a
sector count, with no intervening spaces.  EXCEPTIONALLY DANGEROUS. DO
NOT USE THIS FLAG!!"

Maybe this option can be useful for you. As I can understand, it can be
helpful in the case necessity to check TRIM support by device.

With the best regards,
Vyacheslav Dubeyko.

> Got this off the Internet.  The last step NEVER returns zero's for either
> 'nilfs' or 'ext4'.
> 
> If you happen to know of a better test, that would be appreciated.
> 
> Thanks for your attention.
> Best regards,
> Mark Trumpold
> 
> 
> -----Original Message-----
> From: Vyacheslav Dubeyko [mailto:slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org]
> Sent: Tuesday, September 04, 2012 11:31 PM
> To: Mark Trumpold
> Cc: 'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> Subject: Re: 'nilfs' TRIM issue?
> 
> Hi Mark,
> 
> On Tue, 2012-09-04 at 16:32 -0700, Mark Trumpold wrote:
> > Greetings,
> >
> > I am seeing the following message a few minutes after booting a system:
> >
> 
> Do you use NILFS as root file system?
> 
> > "NILFS warning: error -95 on discard request, turning discards off for the device"
> >
> 
> As I can see from message that operation is not supported (-95). So, it means that you try to use discard in the case of no support of it on the flash.
> 
> How did you mount NILFS (I mean mount options)?
> Could you share mount utility output without any options?
> Could you share content of your fstab file?
> 
> > We are using the "Satadom-150" flash part which does support TRIM, as
> > evidenced by 'ext4' filesystems having no issue with the mount 'discard' option.
> >
> 
> You want that it hasn't any error message when you use 'discard' mount option in the case no support of it on flash. Am I correct?
> 
> With the best regards,
> Vyacheslav Dubeyko.
> 
> 
> > I am running:
> >    Debian 6.0.5
> >    Linux kernel 3.3.1
> >    Nilfs-utils 2.1.1
> >
> > Any thoughts would be greatly appreciated.
> >
> > Thanks in advance,
> > Mark Trumpold
> >
> >
> > Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.
> 
> >
> > IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.
> >
> > E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.
> 
> IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.
> 
> E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
