From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Wed, 20 Sep 2017 13:09:31 -0600
Message-ID: <eb3069f4-7803-32a0-0503-4258d47bb54d@kernel.dk>
References: <1505928371-27829-1-git-send-email-longman@redhat.com>
 <20170920133238.6d48fb93@gandalf.local.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJNPQrl7q7iu3RUSzVAO6lRHIHwZxg4WY8oozm1mtQo=;
        b=f1vZ8rFQTXwuysm9Ah3q3n8EB6eDtV33lxckIYfsWmU6AMHf/cVzLP/ViyyAUhGjcF
         A+adtcoFY3DSXiMxbxqNOJsr0i4y+9nbf32wduIWfMgnHKiKA8xVVvILOu9i3j21o32B
         GTjWMniVp5Bhdyf4LYNZN1PGnrf0NeMzFcNCjVh/lC59vS7Fd3wPvusuoBAYyBDM8TDP
         9t1YtCkJ5VoSyjLendMr/TSHYNXwzgOjMTLIcoSpYwor0rvaUj7CVwuRkAmQjP9iuvUY
         JvwXlRfgUyXm4t4pA+8QjJ/o4UuULSPweqzGgnAzBTdM1khSBJXmkGJlOIZ/Cd/0FNvx
         z5og==
In-Reply-To: <20170920133238.6d48fb93@gandalf.local.home>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@infradead.org>

On 09/20/2017 11:32 AM, Steven Rostedt wrote:
> 
> Christoph,
> 
> Can you give an acked-by for this patch?
> 
> Jens,
> 
> You want to take this through your tree, or do you want me to?
> 
> If you want it, here's my:
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I'll take it through my tree, and I'll prune some of that comment
as well (which should be a commit message thing, not a code comment).

-- 
Jens Axboe

