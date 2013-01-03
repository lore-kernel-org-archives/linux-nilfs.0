From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_cleanerd cannot open nilfs on device that exists
Date: Thu, 3 Jan 2013 13:44:51 +0300
Message-ID: <7CC3E0B8-A29B-43E8-BCE1-A8FC09F14046@dubeyko.com>
References: <20121212145116.GE3064@wloczykij> <20121212145454.GF3064@wloczykij> <20121212161054.GG3064@wloczykij> <7A92569A-D56B-45B0-9305-EBC2EDF90913@dubeyko.com> <20121212212018.GH3064@wloczykij> <CAB7xdinBgjcLuKL6+Ydtz1mADDGv1kbw+wZ1Y=hOO1VF++iS1A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=L6N5mA1H83T3q3HsUyaGiIBO+OEuMKtB077WV6pbU5E=;
	b=hTHpBloa/MRRM2rqHYnLkx+KDcNbRsYKz43dxG/IJSQt33osBbw80D5wkG8K/7AraByvBsYQSNExqcl+55dIZAfFdCzuS/vRVLWr/1gN95Q8ab/2PU2kubbmTd1rU+Sm;
In-Reply-To: <CAB7xdinBgjcLuKL6+Ydtz1mADDGv1kbw+wZ1Y=hOO1VF++iS1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Jan 3, 2013, at 1:51 AM, sheng qiu wrote:

> Hi all,
> 
> i am new on nilfs2. i want to collect the information about the segment cleaning overhead. for example, how many valid data copied during segment cleaning process. Can anyone give me some hint where i can add these stats codes within the nilfs2 source code? or which source files are related with segment cleaning? 
> 

The segments' cleaning code is distributed between nilfs-cleanerd daemon and NILFS2 driver itself. The nilfs-cleanerd daemon is a part of nilfs-utils. It collects information about dirty segments and initiates cleaning activity by means of ioctl on the driver side. So, you can see nilfs-cleanerd source code and linux/fs/nilfs2/ioctl.c source code as starting points. It is used in cleaning activity, as minimum, nilfs_ioctl_get_bdescs() and nilfs_ioctl_clean_segments(). I think that, maybe, it will be more easy and useful to use user-space nilfs-cleanerd side. Moreover, maybe, it make sense to use blktrace utility for your research as additional tool.

What information do you want to get for your research? How do you plan to analyze and interpret segments cleaning overhead?

But, currently, I think that such research can be a very difficult task because of unpredictability of cleaning overhead nature. It depends from filesystem aging state and history of previous filesystem operations very much, from my point of view. What the purpose of your research activity? Could you share results of your research in the direction of segments cleaning overhead?

With the best regards,
Vyacheslav Dubeyko.

> I will be very appreciated for your help. 
> i tried to send email through the linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, however it fails to deliver, i have to write my email by replying this. hope you won't mind.
> 
> Thanks,
> Sheng
> 
> -- 
> Sheng Qiu
> Texas A & M University
> Room 332B Wisenbaker    
> email: herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> College Station, TX 77843-3259

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
