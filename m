From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] nilfs2: add a tracepoint for tracking stage transition
 of segment construction
Date: Sun, 14 Sep 2014 16:20:33 +0900
Message-ID: <CAE1WaKLSHTBNFpOkv8_brjO4He94yC-4cxBXJd+MpoYDrmmxcA@mail.gmail.com>
References: <1410621276-29867-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<20140914.130913.1849218538834852743.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ARjUWuAHtK3ZcijGyu5RoMdiILawK+J3KpHMHs7/5mo=;
        b=toOnMXHyqThN1dIwm7BGaTNqbOSpcE2FVh93uOoObLlBlS6X/RjGTpaQx4s1EhxwvY
         F75N59fZb+/3Eivgmnad4gvtNGG9n3rv+Xi04t8STmbbCvkVuvZWrASSKrEBb84ZCYC+
         ygFFdQlhiBoODzLoGN6OAvqb/sjjQdoYcIuXR5N0BanYiaWBji4/o3O8VQWiIvA2T2U1
         ZhH1ah4EIw1f194EVCVoHWGiXNWpfupMEjp9czV1cTZe0gExGLmYC8dFPeoAjF9hGVYS
         cSRdvKGh+QdO9SED4h1pieb6iu37NEt8GRXohoaXqNSgMYQGOhmt3TqWmsvPzWvc2+fD
         5miw==
In-Reply-To: <20140914.130913.1849218538834852743.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Sep 14, 2014 at 1:09 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> On Sun, 14 Sep 2014 00:14:36 +0900, Mitake Hitoshi wrote:
>> This patch adds a tracepoint for tracking stage transition of block
>> collection in segment construction. With the tracepoint, we can
>> analysis the behavior of segment construction in depth. It would be
>> useful for bottleneck detection and debugging, etc.
>>
>> The tracepoint is created with the standard trace API of linux (like
>> ext3, ext4, f2fs and btrfs). So we can analysis with existing tools
>> easily. Of course, more detailed analysis will be possible if we can
>> create nilfs specific analysis tools.
>>
>> Below is an example of event dump with Brendan Gregg's perf-tools
>> (https://github.com/brendangregg/perf-tools). Time consumption between
>> each stage can be obtained.
>>
>> $ sudo bin/tpoint nilfs2:nilfs2_collection_stage_transition
>> Tracing nilfs2:nilfs2_collection_stage_transition. Ctrl-C to end.
>>         segctord-14875 [003] ...1 28311.067794: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_INIT
>>         segctord-14875 [003] ...1 28311.068139: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_GC
>>         segctord-14875 [003] ...1 28311.068139: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_FILE
>>         segctord-14875 [003] ...1 28311.068486: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_IFILE
>>         segctord-14875 [003] ...1 28311.068540: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_CPFILE
>>         segctord-14875 [003] ...1 28311.068561: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_SUFILE
>>         segctord-14875 [003] ...1 28311.068565: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_DAT
>>         segctord-14875 [003] ...1 28311.068573: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_SR
>>         segctord-14875 [003] ...1 28311.068574: nilfs2_collection_stage_transition: sci = ffff8800ce6de000, stage = ST_DONE
>>
>> For capturing transition correctly, this patch adds wrappers for the
>> member scnt of nilfs_cstage. With this change, every transition of the
>> stage can produce trace event in a correct manner.
>>
>> Of course the tracepoint added by this patch is very limited, so we
>> need to add more points for detailed analysis. This patch is something
>> like demonstration. If this concept is acceptable for the nilfs
>> community, I'd like to add more tracepoints and prepare analysis
>> tools.
>>
>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> ---
>>  fs/nilfs2/segment.c           | 71 +++++++++++++++++++++++++++++++------------
>>  fs/nilfs2/segment.h           |  3 +-
>>  include/trace/events/nilfs2.h | 50 ++++++++++++++++++++++++++++++
>>  3 files changed, 103 insertions(+), 21 deletions(-)
>>  create mode 100644 include/trace/events/nilfs2.h
>>
>> v3: undo rename
>>
>> v2: correct the email address of author
>>
> <snip>
>
> Looks good.  I pushed out this patch as "tracepoints" branch of
> nilfs2.git[1].
>
> If you hope it to be sent to upstream separately at this time, please
> let me know.  (In that case, the following description should be
> revised to be ready for mainline merge).
>
>> Of course the tracepoint added by this patch is very limited, so we
>> need to add more points for detailed analysis. This patch is something
>> like demonstration. If this concept is acceptable for the nilfs
>> community, I'd like to add more tracepoints and prepare analysis
>> tools.
>
> Otherwise, I'll keep it in the tracepoints branch for now.

Thanks a lot for your review and pushing. The change for tracepoints
doesn't need to be sent to upstream immediately. I'll enhance the
feature for a while on the tracepoints branch.

Thanks,
Hitoshi

>
> [1] https://github.com/konis/nilfs2.git
>
> Thanks,
> Ryusuke Konishi
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
