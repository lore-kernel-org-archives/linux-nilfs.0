From: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Subject: RE: 'nilfs' TRIM issue?
Date: Thu, 6 Sep 2012 14:32:08 -0700
Message-ID: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F83614@Etamin.tachyon.net>
References: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835B3@Etamin.tachyon.net>
	<1346826651.2096.9.camel@slavad-ubuntu-11>
	<CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835DE@Etamin.tachyon.net>
 <20120906.190213.265079658.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120906.190213.265079658.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Rodriguez <Eric.Rodriguez-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>

Hello,

Fascinating..  I can finally see some cause/effect.  Your method worked:
>  # dd if=/dev/urandom of=/dev/sdc2
>  # mkfs -t nilfs2 -v /dev/sdc2    <-- does the TRIM request
>  # dd if=/dev/sdc2 iflag=direct 2> /dev/null | hexdump

What's interesting is in a working case,  every 16mbyts of zero's there is ~4k non-zero/random data.  I'm assuming this is the way it is supposed to work.

Also, given this new test I determined that TRIM does NOT work on the flash part on our target system, so the original message is legitimate:

"NILFS warning: error -95 on discard request, turning discards off for the device"

Thank you both for your helpful input!
Regards,
Mark Trumpold



> -----Original Message-----
> From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org]
> Sent: Thursday, September 06, 2012 3:02 AM
> To: Mark Trumpold
> Cc: Vyacheslav Dubeyko; linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Eric Rodriguez
> Subject: Re: 'nilfs' TRIM issue?
>
> On Wed, 5 Sep 2012 13:52:20 -0700, Mark Trumpold wrote:
> > Hello Vyacheslav,
> >
> > > Do you use NILFS as root file system?
> > >
> > Actually, 'nilfs' on this system is just a container that contains
> > loop images, one of which is the root filesystem.  As you can see this
> > is a little out of the norm, so I think I should do more homework
> > before involving a lot of your time..  At this point it in not clear
> > if TRIM is working at all for 'ext4' or 'nilfs' on our system.  It may
> > be that the warning from 'nilfs' is legitimate.
>
> Actually, ext4 does not emit warning even if the TRIM is not supported by
> underlying block devices; it simply ignores the error status of the discard
> request.
>
> > I think it might be best for me to first find a way to test whether or
> > not TRIM is working in general for a particular configuration.
> > I've gone to a totally generic system with just a test 'nilfs' and 'ext4'
> > partition to get some experience.  One thing I've noticed is 'ext4'
> > does not complain if you mount with 'discard' on a device that does
> > NOT support it -- so that's no help.
> >
> > I've tried the following simple sequence:
> > dd if=/dev/urandom of=tempfile bs=1M count=3
> > hdparm --fibmap tempfile    <-- get start address of the file
> > hdparm --read-sector [ADDRESS] /dev/sda rm tempfile && sync && sleep
> > 120
> > hdparm --read-sector [ADDRESS] /dev/sda   <-- should be all zero's
> >
> > Got this off the Internet.  The last step NEVER returns zero's for
> > either 'nilfs' or 'ext4'.
> >
> > If you happen to know of a better test, that would be appreciated.
>
> mkfs.nilfs2 issues TRIM/DISCARD by default.
>
> With mkfs.nilfs2, you can test if the TRIM is supported on the device if you
> have an empty partition:
>
>  # dd if=/dev/urandom of=/dev/sdc2
>  # mkfs -t nilfs2 -v /dev/sdc2
>
>  where /dev/sdc1 is the empty partition in this example.
>
> You will see the following message if TRIM is supported.
>
>  Discard succeeded and will return 0s - skip wiping
>
> Then, you can confirm the device is actually cleared, for exapmle, with dd
> command:
>
>  # dd if=/dev/sdc2 iflag=direct 2> /dev/null | hexdump
>
>
> With regards,
> Ryusuke Konishi
>
>
> > Thanks for your attention.
> > Best regards,
> > Mark Trumpold
> >
> >
> > -----Original Message-----
> > From: Vyacheslav Dubeyko [mailto:slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org]
> > Sent: Tuesday, September 04, 2012 11:31 PM
> > To: Mark Trumpold
> > Cc: 'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> > Subject: Re: 'nilfs' TRIM issue?
> >
> > Hi Mark,
> >
> > On Tue, 2012-09-04 at 16:32 -0700, Mark Trumpold wrote:
> > > Greetings,
> > >
> > > I am seeing the following message a few minutes after booting a system:
> > >
> >
> > Do you use NILFS as root file system?
> >
> > > "NILFS warning: error -95 on discard request, turning discards off for the
> device"
> > >
> >
> > As I can see from message that operation is not supported (-95). So, it
> means that you try to use discard in the case of no support of it on the flash.
> >
> > How did you mount NILFS (I mean mount options)?
> > Could you share mount utility output without any options?
> > Could you share content of your fstab file?
> >
> > > We are using the "Satadom-150" flash part which does support TRIM,
> > > as evidenced by 'ext4' filesystems having no issue with the mount
> 'discard' option.
> > >
> >
> > You want that it hasn't any error message when you use 'discard' mount
> option in the case no support of it on flash. Am I correct?
> >
> > With the best regards,
> > Vyacheslav Dubeyko.
> >
> >
> > > I am running:
> > >    Debian 6.0.5
> > >    Linux kernel 3.3.1
> > >    Nilfs-utils 2.1.1
> > >
> > > Any thoughts would be greatly appreciated.
> > >
> > > Thanks in advance,
> > > Mark Trumpold
> > >
> > >
> > > Confidentiality Notice:  The information contained in this electronic e-mail
> and any accompanying attachment(s) is intended only for the use of the
> intended recipient and is confidential and/or privileged. If you and we have a
> confidentiality agreement or other non-disclosure obligations between us,
> this Notice shall be deemed to mark and identify the content of this email
> and any attachments as confidential and proprietary.   If any reader of this
> communication is not the intended recipient, unauthorized use, disclosure or
> copying is strictly prohibited, and may be unlawful.  If you have received this
> communication in error, please immediately notify the sender by return e-
> mail, and delete the original message and all copies from your system.  Thank
> you.
> >
> > >
> > > IRS Circular 230 Disclosure: To ensure compliance with requirements
> imposed by the IRS, please be advised that any U.S. federal tax advice
> contained in this communication (including any attachments) is not intended
> or written to be used or relied upon, and cannot be used or relied upon, for
> the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii)
> promoting, marketing or recommending to another party any transaction or
> matter addressed herein.
> > >
> > > E-mail is susceptible to data corruption, interception, unauthorized
> amendment, tampering and viruses, and we only send and receive e-mails
> on the basis that we are not liable for any such corruption, interception,
> amendment, tampering or viruses or any consequences thereof.
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> >
> > Confidentiality Notice:  The information contained in this electronic e-mail
> and any accompanying attachment(s) is intended only for the use of the
> intended recipient and is confidential and/or privileged. If you and we have a
> confidentiality agreement or other non-disclosure obligations between us,
> this Notice shall be deemed to mark and identify the content of this email
> and any attachments as confidential and proprietary.   If any reader of this
> communication is not the intended recipient, unauthorized use, disclosure or
> copying is strictly prohibited, and may be unlawful.  If you have received this
> communication in error, please immediately notify the sender by return e-
> mail, and delete the original message and all copies from your system.  Thank
> you.
>
> >
> > IRS Circular 230 Disclosure: To ensure compliance with requirements
> imposed by the IRS, please be advised that any U.S. federal tax advice
> contained in this communication (including any attachments) is not intended
> or written to be used or relied upon, and cannot be used or relied upon, for
> the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii)
> promoting, marketing or recommending to another party any transaction or
> matter addressed herein.
> >
> > E-mail is susceptible to data corruption, interception, unauthorized
> amendment, tampering and viruses, and we only send and receive e-mails
> on the basis that we are not liable for any such corruption, interception,
> amendment, tampering or viruses or any consequences thereof.
> >


Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.

IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.

E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
