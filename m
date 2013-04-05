From: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Subject: Re: NILFS2 and data integrity
Date: Fri, 5 Apr 2013 17:48:12 +1100
Message-ID: <201304051748.12466.onlyjob@member.fsf.org>
References: <201304051545.16927.onlyjob@member.fsf.org> <1365142569.2075.14.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:subject:date:user-agent:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        bh=VzYFQ2kVIK3nm/o4RPkzDOB23yb1UCjJ7LoSoYX6V0U=;
        b=NfDipv8SNsh3e9gZiTkadwmsKR8q73gMmz9oBTRZRNBK/S3hpzJSxxkHWrKENffrAN
         ZIifCISsnec+w3FT+BB+7Qn+UErPOBZD7qU25JT2VXGXPQgtgD9Ff/NHAhHC59gFeES7
         LijHmZKGzxyJ+51eZmLJdUunPHqM2jd6WRJZPEEvXBGp8H+8KzDImaktQtCYzFKkcVCM
         YUO4qU0p453KHBwZRYrogpUv+AFVR6f3RGKfaxHXWXr5tAcWY70oTQvCIcWZtZwFKSzp
         m8xr7FJ/1GpGtVtFOaBTt6xnK/aFtBK5vwh4scEtNpAxgIp+tfDlEe77hs9MbvsQ8bev
         BB5w==
In-Reply-To: <1365142569.2075.14.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On Fri, 5 Apr 2013 17:16:09 Vyacheslav Dubeyko wrote: 
> First of all, I think that it needs to distinguish two issues in your
> e-mail. The first one is the issue with Samsung HDD and the second is
> the issue with "bad b-tree node".

I was able to reproduce "bad b-tree node" on data-corrupting HDD.
I think it is happening when previously corrupted b-tree is read.

It looks like when only data is corrupted there is no "bad b-tree node"
problem.

 
> Yes, I think that you are really right about necessity to check data
> integrity during segctor and nilfs_cleanerd activity.

Thank you. :)


> The issue with "bad b-tree node" is reported by many guys. But it is not
> not easy to reproduce the issue for 4 KB block size on my side.
> Currently, I can reproduce the issue on NILFS2 volume with 1 KB block
> size. And I am deeply inside investigation of the issue in such
> environment. But it is possible that such use-case can be a 1 KB block
> size related. Currently, I doubt that we have one reason for "bad b-tree
> node" issue.

I'm sure there might be other reasons for this. However I only experienced
"bad b-tree node" in connection with data corruption caused by
malfunctioning HDD with buggy firmware.

Regards,
 Dmitry.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
