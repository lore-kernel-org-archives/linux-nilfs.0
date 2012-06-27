From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs checkpoints tied to synchronous writes
Date: Wed, 27 Jun 2012 10:16:54 +0400
Message-ID: <1340777814.1959.15.camel@slavad-ubuntu-11>
References: <CDB9B1D21E35BB4C9E8124D05FD86BB184ABA761A0@Etamin.tachyon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=pKT0Ti/ed2Pd28NghcFYguU+GuCG236+520s3cXqVpw=;
	b=m37fEZR+AUB+ckoIhBT8Yv650og82RYSAwKQ8aPCl5MJytL+chv+30dLD00kiai4L6zD5nFXzy9PEx4Sh4W4vXBXdkdv9dp6/ojTxHiy4PWxYfOAQhCstn9NKcAcgavK;
In-Reply-To: <CDB9B1D21E35BB4C9E8124D05FD86BB184ABA761A0-Nr8giE/DiON166AYIJghu6xOck334EZe@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <Mark.Trumpold-PJstQz4BMNNBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "; Vyacheslav.Dubeyko"@huawei.com

Hi Mark,

On Mon, 2012-06-25 at 18:11 -0700, Mark Trumpold wrote:
> Hello,
> 
> I have a configuration where I use qemu/qcow loop filesystems
> on top a nilfs filesystem to yield writeable snapshots.
> 
> The symptom I see is the nilfs filesystem "ballooning" in size when
> writing large chunks of data to the qcow loop filesystem.  I also see
> _many_ nilfs checkpoints with small "NBLKINC" counts (>20  <50).
> 
> My working theory is nilfs creates checkpoints for each synchronous
> write, and qcow insists on writing synchronously, thus the ballooning
> of checkpoints.

I can cite man page for NILFS2:
"When data is written or any change is made to a NILFS2 file system, it
automatically creates a checkpoint.  A checkpoint represents a
consistent state of the NILFS2 file system of a certain instant.".

> 
> One question is would it be possible to have nilfs not checkpoint so
> often.  I've tried the 'nilfs-tune -i ..' to no avail - apparently
> synchronous writes overrule this setting.

As you can see, checkpoint is a base technique of NILFS2 functioning.
But you can manipulate by checkpoints during NILFS2 functioning by means
of nilfs-cleanerd daemon.

Do you use nilfs-cleanerd daemon?

Please, read man page for nilfs-cleanerd daemon and its configuration
file. I can cite man page:
"nilfs_cleanerd is a system daemon which reclaims disk space of NILFS2
file system found in device."

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
