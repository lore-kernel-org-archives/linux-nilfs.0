From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Wed, 15 Jan 2014 12:44:25 +0100
Message-ID: <CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
References: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
	<1389783139.3913.23.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=ohlLfm/ZCdGsS54udVtwwsAHvsJHjaZZpAEkIbCeEl8=;
        b=iCRBLgd/+ns+ZnDgrpPSAwLRxhYFrs9zer9DL+aD8iosKKXuDRS5QoMfZ82+s8PV5g
         rv/UM+wcYalV+yF5EO3Y5CC3gBP0Xq+BvunoqNXY4OqG7DIdTkInlvK9gSo3gqlCWzw7
         XYHYXnB1o84SqsfszVzjQ/TlvObriiZV8/wN58tbddl4cDBI86Mq9jXSdbwFA2Zh8jYC
         zpHbnfDEihqz8Gu7mcXrS58d31H5T2iqNGOHMj7poHbWJNomAXjXb3v/0P1D3T9bCtiN
         yUCpsDZUKQAMcAV5udzWaJA2KQJBwNq/DUarLJM3eHGeJV/T0IR5eZkwkaOk7oBN1OR9
         ygPg==
In-Reply-To: <1389783139.3913.23.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> The main approach of NILFS2 is COW (copy-on-write) policy. It means that
> all data and metadata are written in log manner. Only superblocks are
> placed in fixed positions and updated there. First superblock is located
> in the volume begin, second one in the volume end.

Can you give me an estime how often the superblock is updated / written to?

Thanks a lot, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
