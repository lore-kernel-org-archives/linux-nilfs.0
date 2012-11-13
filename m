From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 10:13:38 +0400
Message-ID: <1352787218.2042.9.camel@slavad-ubuntu>
References: <50A159BC.9060600@li.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=o9DhEsSOYvu2lxtBkSy74X4a/CBezcn34/Os/LZOEBc=;
	b=S1B7I55ytq7gfdkL1WS8uhryE4cuR9v7SWY4FLkAKtOQRaBng2Z76L/eVsaqJ8TxB2WITtfg/+V6iBGDf8KUjO6vThmJ32JWp5VSTAeEk3sBs1mWtKNL68/cGWnimYV1;
In-Reply-To: <50A159BC.9060600-3TRaYzfGuuI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-11-13 at 00:19 +0400, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org wrote:
> Hello!
> Some time ago I've noticed, that "flush" kernel process associated with 
> device running nilfs2 filesystem, generate huge amount of IO activity 
> (using 100% CPU time). "iotop" utility show speeds about 5-15 GB\S on 
> that "flush" process, but no actual disk activity happens.

Sorry, but I have some misunderstanding. From one point of view, you
said that filesystem generates I/O activity but as a result you haven't
disk activity. Does it means that you create any files but you haven't
it on partition after umount?

> This condition lasts about 1-2 minutes, and then it stops for some time 
> (usually 10-20 minutes).
> 
> Is this a normal behavior ? I'm using kernel 3.6, and nilfs running on 
> luks-encrypted partitions, that belongs to software raid-1 array.
> 

Could you share more details about your configuration and situation?

Please, share:
1. System log content related to the problem (NILFS2, I/O subsystem).
2. Output of "top" and "ps -ax" in the case of the issue.
3. Describe your partitions and disks configuration ("mount" output,
"cat /proc/partitions" output).
4. Output of "lscp" and "lssu".

With the best regards,
Vyacheslav Dubeyko.

> //Sorry for my English
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
