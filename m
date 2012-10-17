From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs fault tolerance
Date: Wed, 17 Oct 2012 23:25:48 +0400
Message-ID: <07527340-AA40-4C57-B5AA-6811AEEFA39E@dubeyko.com>
References: <CCA3FC93.7170%markt@tachyon.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=dssbT7KbtifyYRItIgIr7aLfCr9oSH3USLSMuIZZckI=;
	b=cXWtZXs8qVQqttwAHO2ctN0p3MGhFQAk5WpmtmaiSy3lzJGh6UffH7uj+2tGjGD1qoaTaGZb3s943NtpBz9GR5TZ4ZWPz3twPAJGUzmOpyPyWqkX6YEVDkhgQlHRAzzJ;
In-Reply-To: <CCA3FC93.7170%markt-PJstQz4BMNPR7s880joybQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Mark,

On Oct 17, 2012, at 5:11 PM, Mark Trumpold wrote:

> Hello all,
> 
> I have been using nilfs for some time now, and am quite happy with the
> features and performance.
> 
> I have also been promoting it as a filesystem of choice for 'appliances'
> that as normal course do not get gracefully shutdown (power switch off).
> This robustness bears out in my own testing.
> 
> The recent posts regarding "corrupt root inode" have me a little concerned
> about my understanding.
> 
> Is my current assumption correct, in that if the hardware does something
> weird and scribbles badly to the filesystem, then obviously all bets are
> off --- otherwise nilfs should be robust against the 'power off' (no
> graceful shutdown)?
> 

I think that currently above-mentioned issue (NILFS: corrupt root inode after Turbo Mode?) can't be a basis for discussion. From my point of view, we have currently unreproducible issue with absence of reproducing path description. An issue should be steady reproducible firstly, from my point of view. I haven't whole picture of situation on the volume currently. So, I think that it is early to discuss about something.

Why do you think that it was sudden power-off? We haven't reproduction path of the issue. So, we don't know the reason and technical environment of the issue. This concrete NILFS2 filesystem lives from August and it was successfully mounted 56 times. It has some strange state of primary and secondary superblocks. So, it was not enough information for any conclusions.

I suspect the hardware reason but I haven't strict evidence of it.

With the best regards,
Vyacheslav Dubeyko.

> Thanks in advance,
> Mark T.
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
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
