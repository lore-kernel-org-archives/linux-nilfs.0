From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block_dev: Rename bd_fsfreeze_mutex
Date: Mon, 18 Sep 2017 16:47:45 -0700
Message-ID: <20170918234745.GA8600@infradead.org>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
 <1505760831-7747-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dMFdpRetNQxXk8F1JP/7CjemXK0xdS/29eaf9WVcjkI=; b=o3ZDumR2DvKlDDtmIbcITPjzn
        O/BTXbOWDpwZpXizgKb/LEdkep8lAvi6A+ozlRkZ7l1Z4UmJSqhzg36qdDgw7IE3D/x1PG8CjwYZp
        2U68J5cNO/VmmuMYJJmvok3IPsdrF4kFPQrHzVs5V652ynV11788bT6Ap6kGoyyI4kWNfBhdwRUaH
        JDUGnyBL9SuYaxW+3gI/rsCuepjMK4p05xyX0EvylS/O/MRqeIui9Yq09qTDBdOBvIlvpLdS5u9Cr
        UIlnsf2Srz6Lx37nJOzr6n50fWCZykzFpP5E8VZbry0xsP0C0yhlZJsOK4TAuMRQSOZOt+21zLQeQ
    
Content-Disposition: inline
In-Reply-To: <1505760831-7747-3-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>

Don't rename it to a way to long name.  Either add a separate mutex
for your purpose (unless there is interaction between freezing and
blktrace, which I doubt), or properly comment the usage.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
