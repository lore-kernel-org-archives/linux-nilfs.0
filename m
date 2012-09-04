From: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Subject: 'nilfs' TRIM issue?
Date: Tue, 4 Sep 2012 16:32:11 -0700
Message-ID: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835B3@Etamin.tachyon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Greetings,

I am seeing the following message a few minutes after booting a system:

"NILFS warning: error -95 on discard request, turning discards off for the device"

We are using the "Satadom-150" flash part which does support TRIM, as evidenced
by 'ext4' filesystems having no issue with the mount 'discard' option.

I am running:
   Debian 6.0.5
   Linux kernel 3.3.1
   Nilfs-utils 2.1.1

Any thoughts would be greatly appreciated.

Thanks in advance,
Mark Trumpold


Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.

IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.

E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
