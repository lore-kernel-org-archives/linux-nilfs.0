From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unrecovered read error issue
Date: Sun, 20 Dec 2015 19:34:13 +0100
Message-ID: <CAFvQSYTHYypic+bjUOxK=F81XgA1zOvviKkAKQuJ2fD==tn02w@mail.gmail.com>
References: <1450488372.2652.25.camel@slavad-ubuntu-14.04>
	<20151219071703.GP3706@home.paul.comp>
	<1450562290.2693.9.camel@ubuntu-slavad-14.04>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=oj56AUT2cjN7qRRWArBIK4wu4Fo2ikjiuFtasX0aZr8=;
        b=atbzs70D2toWPAJrMXDpMQT2Tq0BNjVC+4pf3XyK7FGK/V9E63VtdcrJ8kF4iG9AhI
         0Of4bKf7ES4vHOgcIJslBmpOhMtOw3VxY5Qd+3jrdsV1WHvr0Z01hL6GLOFdoP9ER3VG
         rSjmbHW3hQH8ONCrI/AuQitdODDSPJcAgiqq2WJ4LQPPVDWsQ64qVYDgR+RlR4eYesCD
         7Idoq3wC4H35pvGQ1aBLvBqLu79lgJVOfGgJ+tq3PvIkdrk1W0vD+KsPojpMnNEPd3oO
         9cu4ngHRUjluxhbcwsD5GbK1pH7kfZuT6TbvprV4sxMUP83cYsujsdtF4aA7DlVvTChN
         sgRA==
In-Reply-To: <1450562290.2693.9.camel-RC04EVaD3rlUdzgqiOAiT0EK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,


> But I suppose that eMMC or SSD will do re-assignment of bad logical
> sector into valid physical page on write operation. And I am not sure
> that bad sector will be re-assigned on write operation for HDD case.

Modern (SMART-capable) HDDs behave exactly the same - they have spare
sectors and remap bad sectors when writing them. I "fixed" a laptop
HDD once, which had a head-crash at the place where ext4's journal was
located - a simple overwrite with dd fixed the drive.

Best regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
