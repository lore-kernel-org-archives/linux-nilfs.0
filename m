From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Wed, 1 Jun 2011 19:34:30 +0200
Message-ID: <201106011934.30725.dexen.devries@gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com> <201106011003.24656.dexen.devries@gmail.com> <BANLkTimhLPM3TU1uw10Ub5t-GEW_s-B_tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=oapaTZiRZg6wRVMy2T5j5ds6YKGt+kxOBeNR14df96c=;
        b=Vg/OtT3c4iaNfKHPRliwWN52+ypM7UpEX3GsiAA7XEe1MQ9+hr+kF+NksCu0tE/k5W
         J7atB5fe1pVXsjPd6mZfBTuCMAHcJbwByJlCre+pqb+yPtpr0HDFsFV7Wfh6whkxSuhL
         hERHrT8leLz5vchF8HWG1z/sfg+1UboMelX0c=
In-Reply-To: <BANLkTimhLPM3TU1uw10Ub5t-GEW_s-B_tQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dima,


On Wednesday 01 June 2011 19:32:07 you wrote:
> I'm trying to analyze how different filesystems, settings and user
> mode settings interact with write amplification and write endurance on
> flash.
> 
> Thus I need to get details of every write that fs issues to the
> underlying block device.

Have you considered either of:


# iostat -d -k 1

http://linux.die.net/man/8/blktrace


-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
