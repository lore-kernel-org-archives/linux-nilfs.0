From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Wed, 20 Sep 2017 10:35:52 -0700
Message-ID: <20170920173552.GA14611@infradead.org>
References: <1505928371-27829-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=y76MFECZZEIYYGOuMFwK0wbV0w703Qj5LSs9ffOB8x0=; b=MdtEnc3IXC3EnDWV5Gi5192IC
        qfni5p51TLYRQVe6gKX+c1ovUjVNG8jjpOWPzEddsdvJFlAORPTOT1njCzO+W+dO2CW8Xk+FTuAgj
        w2x9xmSEQo819M+vOzevF4igDu1fMli6xBZ0CrMdiCGvIh5UGqFoT/ZABFMtWrMGJtJpW1yKtHAOf
        kQXJEggLMNcf7nVGYVTGBhbjPvmQqPDodyrnhfh2zIIxxmgUaNXseZyEZfdRyy6bzIrFy9CHspvwv
        ohF92qcOv/Yby0idPg6+mG/BGZdrSZeUdMjaD1DIz4venT3I28egiqeqVc/OkBUMcChwIHH5cL45L
    
Content-Disposition: inline
In-Reply-To: <1505928371-27829-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@infradead.org>

> +/*
> + * When reading or writing the blktrace sysfs files, the references to the
> + * opened sysfs or device files should prevent the underlying block device
> + * from being removed. So no further delete protection is really needed.
> + *
> + * Protection from multiple readers and writers accessing blktrace data
> + * concurrently is still required. The bd_mutex was used for this purpose.
> + * That could lead to deadlock with concurrent block device deletion and
> + * sysfs access. As a result, a new blk_trace_mutex is now added to be
> + * used solely by the blktrace code.
> + */

Comments about previous locking schemes really don't have a business
in the code - those are remarks for the commit logs.  And in general
please explain the locking scheme near the data that they proctect
it, as locks should always protected data, not code and the comments
should follow that.
