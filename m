From: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs checkpoints tied to synchronous writes
Date: Wed, 27 Jun 2012 07:04:11 -0700
Message-ID: <CC105D10.66F1%markt@tachyon.net>
References: <1340777814.1959.15.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340777814.1959.15.camel@slavad-ubuntu-11>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Vyacheslav,

Thank you for your reply.

I have read the man page for nilfs_cleanerd and it's
conf file, and have done quite a bit of experimentation.
It does work as expected.

After reading your email, and more thought I think that
my problem case may have to be solved from the filesystem
writer's side.  I think what is happening is that 'qcow2'
is forcing data to be flushed to disk on every write,
instead of letting the kernel buffer into larger chunks.

Thanks again for input.
Best regards,
Mark T.

On 6/26/12 11:16 PM, "Vyacheslav Dubeyko" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:

>Hi Mark,
>
>On Mon, 2012-06-25 at 18:11 -0700, Mark Trumpold wrote:
>> Hello,
>>
>> I have a configuration where I use qemu/qcow loop filesystems
>> on top a nilfs filesystem to yield writeable snapshots.
>>
>> The symptom I see is the nilfs filesystem "ballooning" in size when
>> writing large chunks of data to the qcow loop filesystem.  I also see
>> _many_ nilfs checkpoints with small "NBLKINC" counts (>20  <50).
>>
>> My working theory is nilfs creates checkpoints for each synchronous
>> write, and qcow insists on writing synchronously, thus the ballooning
>> of checkpoints.
>
>I can cite man page for NILFS2:
>"When data is written or any change is made to a NILFS2 file system, it
>automatically creates a checkpoint.  A checkpoint represents a
>consistent state of the NILFS2 file system of a certain instant.".
>
>>
>> One question is would it be possible to have nilfs not checkpoint so
>> often.  I've tried the 'nilfs-tune -i ..' to no avail - apparently
>> synchronous writes overrule this setting.
>
>As you can see, checkpoint is a base technique of NILFS2 functioning.
>But you can manipulate by checkpoints during NILFS2 functioning by means
>of nilfs-cleanerd daemon.
>
>Do you use nilfs-cleanerd daemon?
>
>Please, read man page for nilfs-cleanerd daemon and its configuration
>file. I can cite man page:
>"nilfs_cleanerd is a system daemon which reclaims disk space of NILFS2
>file system found in device."
>
>With the best regards,
>Vyacheslav Dubeyko.
>



Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.

IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.

E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
