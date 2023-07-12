From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/79] fs: add ctime accessors infrastructure
Date: Wed, 12 Jul 2023 08:31:55 -0700
Message-ID: <03e153ce-328b-f279-2a40-4074bea2bc8f__17553.7191143789$1689175994$gmane$org@infradead.org>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621144507.55591-2-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=689SEK0ciFY8KgDlRHFBreHHAC2z+cvH0wQ011Q2aMI=; b=df/VKiT91ZqRa0x7ofoJaXGlph
        PM7CRP4KkwoXZKNJlvYdkig+/LLrQ9LVGVf40H6Qaywx20JwTqHlizlUxF15FF/hdi7QMcfJ88rOM
        Tk9o3z44pMTcermnTCrLWAF39fzqRsD0ms+1lMmZtzToJzTD0SUcPG6eXBFgIigvbDeEBrSIYXiW/
        GnykGmmqxl8DWPpBQb6tfrtLGgdO7lnddHDuy7SXW0bC9E1PhpCLadB/V3QSWJPX+bNFvOifeRdsy
        3Vg5gSGOgGr74Cyg+9z9dxsezgnvq5bViTggfgF6K6g7cj7jT1ssxpJXUEt4gBcr4IJbEN74vqTce
        EZsIkLBg==;
Content-Language: en-US
In-Reply-To: <20230621144507.55591-2-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-um <linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

Hi Jeff,

On arch/um/, (subarch i386 or x86_64), hostfs build fails with:

../fs/hostfs/hostfs_kern.c:520:36: error: incompatible type for arg
ument 2 of 'inode_set_ctime_to_ts'
../include/linux/fs.h:1499:73: note: expected 'struct timespec64' b
ut argument is of type 'const struct hostfs_timespec *'


-- 
~Randy
