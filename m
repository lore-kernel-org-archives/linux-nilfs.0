From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: add a tracepoint for tracking stage transition
 of segment construction
Date: Sun, 14 Sep 2014 00:13:42 +0900
Message-ID: <CAE1WaKJy9-s_nQzjW3kHTBtAYCUjnqBYjYhj8JMVmYuQw+co=g@mail.gmail.com>
References: <1409884917-21440-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<1409899243.4164.6.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Mcd6F1UX/NG/fvKVKXV7Tr8INP7/BjEkJEehqVnHQ7A=;
        b=Pd+oG+e8VgkD6OPgOtr4oxia5tKDnP6fkw+BOk0e9I08XYPGrgeA2927mKs9ES7ek1
         EHp0XvjfdOTSNUuBDJ5aF5Phn/on3Zp2NaEHbbRa8A6/HTOgWH1qT9y/P8l6G7fOMSaZ
         Xf+PTIMuWvdSPOvBeToDlgXIThXqeLoM8a/xftK/dMz0DLKbacos1WQgfqc4ObYAdpSF
         STBc2NZlvy6BzNGVlQdT0vSbf4Qiw4ouymRYCP/I9cb4bSY6UFTiuAXvqZmhJoQUKCAe
         dMUFmQKQr77T7GkkwUJt6MIG6DP5RdWU2Icks7nWOMTEWdMNqOJDsDPV+th9nMfT+BDE
         oqPA==
In-Reply-To: <1409899243.4164.6.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 5, 2014 at 3:40 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> On Fri, 2014-09-05 at 11:41 +0900, Hitoshi Mitake wrote:
>
> [snip]
>> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
>> index 38a1d00..1e9b931 100644
>> --- a/fs/nilfs2/segment.h
>> +++ b/fs/nilfs2/segment.h
>> @@ -66,13 +66,14 @@ struct nilfs_recovery_info {
>>
>>  /**
>>   * struct nilfs_cstage - Context of collection stage
>> - * @scnt: Stage count
>> + * @__scnt: Stage count, must be accessed via wrappers:
>> + *          nilfs_sc_cstage_inc(), nilfs_sc_cstage_set(), nilfs_sc_cstage_get()
>>   * @flags: State flags
>>   * @dirty_file_ptr: Pointer on dirty_files list, or inode of a target file
>>   * @gc_inode_ptr: Pointer on the list of gc-inodes
>>   */
>>  struct nilfs_cstage {
>> -     int                     scnt;
>> +     int                     __scnt;
>
> It doesn't make sense this change for my taste. As far as I can judge,
> you've made this change because scnt field should be accessed by means
> of wrappers. But __scnt name doesn't provide from direct using this
> field. So, I suppose that extended comment will be enough.

OK, I'll rename it in v3.

>
> By the way, do you plan to add tracepoints for another NILFS2
> subsystems?

Yes.

Thanks,
Hitoshi

>
> Thanks,
> Vyacheslav Dubeyko.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
