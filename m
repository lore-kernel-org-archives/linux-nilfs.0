From: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Subject: RE: nilfs checkpoints tied to synchronous writes
Date: Wed, 27 Jun 2012 14:40:06 -0700
Message-ID: <CDB9B1D21E35BB4C9E8124D05FD86BB184ABA761F4@Etamin.tachyon.net>
References: <1340777814.1959.15.camel@slavad-ubuntu-11>
	<CC105D10.66F1%markt@tachyon.net>
 <20120628.061420.04584589.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120628.061420.04584589.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Greetings Ryusuke,

I'm floating on air at the moment, as I have a working solution.

Turns out Stephene Chazelas had submitted bug at:
     https://bugs.launchpad.net/ubuntu/+source/qemu-kvm/+bug/595117

AND a small patch to 'qemu-nbd.c', which I applied and tested with
great success.  Since I'm only using the loop filesystem aspect of qemu,
I couldn't use the 'cache=writeback' with the qemu VM tools, as you suggested.

However, with the patch, I can submit the same logic to 'qemu-nbd --cache=writeback ..'

Prior to the patch I would get >10k checkpoints by copying ~1/2gigbyte data
to the loop device -- now I get 2-5 checkpoints -- I'm so stoked!!

Thank you for your kind attention.
NILFS rocks!!

Regards,
Mark T.

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org]
Sent: Wednesday, June 27, 2012 2:14 PM
To: Mark Trumpold
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org; linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: nilfs checkpoints tied to synchronous writes

>On Mon, 2012-06-25 at 18:11 -0700, Mark Trumpold wrote:
> Hello,
>
> I have a configuration where I use qemu/qcow loop filesystems on top a
> nilfs filesystem to yield writeable snapshots.
>
> The symptom I see is the nilfs filesystem "ballooning" in size when
> writing large chunks of data to the qcow loop filesystem.  I also see
> _many_ nilfs checkpoints with small "NBLKINC" counts (>20  <50).
>
> My working theory is nilfs creates checkpoints for each synchronous
> write, and qcow insists on writing synchronously, thus the ballooning
> of checkpoints.

Hi Mark, thanks for your information.

Did you try cache=writeback option on qemu ?

Qemu looks to be using synchronous write operations heavily in its default cache mode.  It's too expensive for underlying filesystems especially for nilfs.

As you pointed out, synchronous write can be separated from checkpointing in theory.  And, nilfs is partially applying such optimization by default (i.e. "order=relaxed" option).  But the current optimization is not sufficient.

I am actually thinking nilfs should have enhanced functionalilty which stops making checkpoints on data integrity operations like fsync or fdatasync.

Unfortunately, it needs disk format extension to make it possible to recover data blocks written by fsync/fdatasync after unexpected shutdown/reboot.  Garbage collector also has to handle such extension.

So, these are one of todo items at present.

Thanks,
Ryusuke Konishi

> On 6/26/12 11:16 PM, "Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>
> >Hi Mark,
> >
> >On Mon, 2012-06-25 at 18:11 -0700, Mark Trumpold wrote:
> >> Hello,
> >>
> >> I have a configuration where I use qemu/qcow loop filesystems on
> >> top a nilfs filesystem to yield writeable snapshots.
> >>
> >> The symptom I see is the nilfs filesystem "ballooning" in size when
> >> writing large chunks of data to the qcow loop filesystem.  I also
> >> see _many_ nilfs checkpoints with small "NBLKINC" counts (>20  <50).
> >>
> >> My working theory is nilfs creates checkpoints for each synchronous
> >> write, and qcow insists on writing synchronously, thus the
> >> ballooning of checkpoints.
> >
> >I can cite man page for NILFS2:
> >"When data is written or any change is made to a NILFS2 file system,
> >it automatically creates a checkpoint.  A checkpoint represents a
> >consistent state of the NILFS2 file system of a certain instant.".
> >
> >>
> >> One question is would it be possible to have nilfs not checkpoint
> >> so often.  I've tried the 'nilfs-tune -i ..' to no avail -
> >> apparently synchronous writes overrule this setting.
> >
> >As you can see, checkpoint is a base technique of NILFS2 functioning.
> >But you can manipulate by checkpoints during NILFS2 functioning by
> >means of nilfs-cleanerd daemon.
> >
> >Do you use nilfs-cleanerd daemon?
> >
> >Please, read man page for nilfs-cleanerd daemon and its configuration
> >file. I can cite man page:
> >"nilfs_cleanerd is a system daemon which reclaims disk space of
> >NILFS2 file system found in device."
> >
> >With the best regards,
> >Vyacheslav Dubeyko.
> >
>
>
>
> Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.

>
> IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.
>
> E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.

IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.

E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
