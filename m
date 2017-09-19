From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v6 1/2] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Mon, 18 Sep 2017 17:01:55 -0700
Message-ID: <20170919000155.GA30806@infradead.org>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=y6T18FBhC4jy+Rv97m+W4gpX2fOqvpcG0wn/MV0+MIA=; b=Sfl9GwiS4IUIoARBr5ogqEoJs
        q4n4/S0Fvwv8rPYfi/lD32ZxS2W5Bj05Offnl0j+gDwhl8AHeYe9zffIkVsI3oebUS2LFnMot/KKL
        kPTVIO1DGJKbhmLbxUU1hr2Bk71CBvjFzf27WkTFPf7WcYrpWSX7CDzc+smQx6WO/bjurJkrItEom
        2LKZF27q0L0bESXRkfrzu1qZD+wGg0232WOn5M9ElxYciZ3b9+4mRuy4t2eAix1VU3GqZjwEl1d0j
        J0ShXqWLsfqO3STre6rZlJovjJ4d+Ygy6+bezweVIXJmiUj/HF9sf+VYic1k3reLrwwvsKhTFnppJ
    
Content-Disposition: inline
In-Reply-To: <1505760831-7747-2-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>

Taking a look at this it seems like using a lock in struct block_device
isn't the right thing to do anyway - all the action is on fields in
struct blk_trace, so having a lock inside that would make a lot more
sense.

It would also help to document what exactly we're actually protecting.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
