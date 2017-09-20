From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7] blktrace: Fix potentail deadlock between delete &
 sysfs ops
Date: Wed, 20 Sep 2017 15:05:36 -0400
Message-ID: <76cc6fea-fd1a-04fb-b18b-04ea5d69dde9@redhat.com>
References: <1505928371-27829-1-git-send-email-longman@redhat.com>
 <20170920173552.GA14611@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170920173552.GA14611-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>

On 09/20/2017 01:35 PM, Christoph Hellwig wrote:
>> +/*
>> + * When reading or writing the blktrace sysfs files, the references to the
>> + * opened sysfs or device files should prevent the underlying block device
>> + * from being removed. So no further delete protection is really needed.
>> + *
>> + * Protection from multiple readers and writers accessing blktrace data
>> + * concurrently is still required. The bd_mutex was used for this purpose.
>> + * That could lead to deadlock with concurrent block device deletion and
>> + * sysfs access. As a result, a new blk_trace_mutex is now added to be
>> + * used solely by the blktrace code.
>> + */
> Comments about previous locking schemes really don't have a business
> in the code - those are remarks for the commit logs.  And in general
> please explain the locking scheme near the data that they proctect
> it, as locks should always protected data, not code and the comments
> should follow that.

It seems to be a general practice that we don't put detailed comments in
the header files. The comment was put above the function with the first
instance of the blk_trace_mutex. Yes, I agree that talking about the
past history may not be applicable here. I will keep that in mind in the
future.

Thanks,
Longman


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
