From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: 'nilfs' TRIM issue?
Date: Wed, 05 Sep 2012 10:30:51 +0400
Message-ID: <1346826651.2096.9.camel@slavad-ubuntu-11>
References: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835B3@Etamin.tachyon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=Tui16HTI4OrC0JjgMquFLlkOO9AkvICrSEDIj1Mwaac=;
	b=iw/C1c9IMN8Pmz8BSoFTkWFUvFFi7E7we5X56uAowWONOs4rHtfYy0CrIF8gSIRVT+miNpE/MLrHGXRKOgPGp5hUVSZXQe0ahZBdFyTAXnySMS5Go0iX4BtXIYYs/cBy;
In-Reply-To: <CDB9B1D21E35BB4C9E8124D05FD86BB189C6F835B3-Nr8giE/DiON166AYIJghu6xOck334EZe@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Cc: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Mark,

On Tue, 2012-09-04 at 16:32 -0700, Mark Trumpold wrote:
> Greetings,
> 
> I am seeing the following message a few minutes after booting a system:
> 

Do you use NILFS as root file system?

> "NILFS warning: error -95 on discard request, turning discards off for the device"
> 

As I can see from message that operation is not supported (-95). So, it
means that you try to use discard in the case of no support of it on the
flash.

How did you mount NILFS (I mean mount options)?
Could you share mount utility output without any options?
Could you share content of your fstab file?

> We are using the "Satadom-150" flash part which does support TRIM, as evidenced
> by 'ext4' filesystems having no issue with the mount 'discard' option.
> 

You want that it hasn't any error message when you use 'discard' mount
option in the case no support of it on flash. Am I correct?

With the best regards,
Vyacheslav Dubeyko.


> I am running:
>    Debian 6.0.5
>    Linux kernel 3.3.1
>    Nilfs-utils 2.1.1
> 
> Any thoughts would be greatly appreciated.
> 
> Thanks in advance,
> Mark Trumpold
> 
> 
> Confidentiality Notice:  The information contained in this electronic e-mail and any accompanying attachment(s) is intended only for the use of the intended recipient and is confidential and/or privileged. If you and we have a confidentiality agreement or other non-disclosure obligations between us, this Notice shall be deemed to mark and identify the content of this email and any attachments as confidential and proprietary.   If any reader of this communication is not the intended recipient, unauthorized use, disclosure or copying is strictly prohibited, and may be unlawful.  If you have received this communication in error, please immediately notify the sender by return e-mail, and delete the original message and all copies from your system.  Thank you.
> 
> IRS Circular 230 Disclosure: To ensure compliance with requirements imposed by the IRS, please be advised that any U.S. federal tax advice contained in this communication (including any attachments) is not intended or written to be used or relied upon, and cannot be used or relied upon, for the purpose of (i) avoiding penalties under the Internal Revenue Code, or (ii) promoting, marketing or recommending to another party any transaction or matter addressed herein.
> 
> E-mail is susceptible to data corruption, interception, unauthorized amendment, tampering and viruses, and we only send and receive e-mails on the basis that we are not liable for any such corruption, interception, amendment, tampering or viruses or any consequences thereof.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
