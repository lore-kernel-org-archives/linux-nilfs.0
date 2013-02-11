From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] fs: encode_fh: return FILEID_INVALID if invalid fid_type
Date: Tue, 12 Feb 2013 07:24:59 +0900
Message-ID: <CAKYAXd8rPwaxe5wzeJ7RfCkkCV22H2FDHzJb4c_D2Qro4eJhXQ@mail.gmail.com>
References: <1360571159-3666-1-git-send-email-linkinjeon@gmail.com>
	<20130211213311.GE8257@dastard>
Mime-Version: 1.0
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=aTu2KMHQnQPtK1sEeIglCwA/ennH6liXIqEL+9z6FWg=;
        b=Rsf4tjoTb8VXUSKQNkFTgdS8JrlK1WcTBNn64wpcCQAB3kN5VaMjiY10X/kunJUUA1
         2sGULWgldQ/jyVxv4OVJH3IXNgmPfXkVOLlttgGwqQ8yrQqvzJRAAOVt3380knQjfWPH
         80cxTBixQ26VkM4y7o/KCspwiO5Daoy13aKmUfBzNVfIr69YfJNvY0wBaMXs6q5epUjD
         lsz1iPSQwq0Xmd9662KvjiRBFYYEkyLt5zxEIIUMOFG2B7rW9c7RH/FkwctgU3Ea9YjF
         Gasox0mxJrkSosrMapdBsrnOGNeFEd9bW07ehP5PzSkAmu/7IMpwFxl+dqecy3GXbavm
         ol7A==
In-Reply-To: <20130211213311.GE8257@dastard>
Sender: reiserfs-devel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: bfields@fieldses.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, chris.mason@fusionio.com, sage@inktank.com, miklos@szeredi.hu, konishi.ryusuke@lab.ntt.co.jp, mfasheh@suse.com, jlbec@ejvilplan.org, jack@suse.cz, bpm@sgi.com, elder@kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Vivek Trivedi <t.vivek@samsung.com>

2013/2/12, Dave Chinner <david@fromorbit.com>:
> On Mon, Feb 11, 2013 at 05:25:58PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch is a follow up on below patch:
>>
>> [PATCH] exportfs: add FILEID_INVALID to indicate invalid fid_type
>> commit: 216b6cbdcbd86b1db0754d58886b466ae31f5a63
> ....
>> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
>> index a836118..3391800 100644
>> --- a/fs/xfs/xfs_export.c
>> +++ b/fs/xfs/xfs_export.c
>> @@ -48,7 +48,7 @@ static int xfs_fileid_length(int fileid_type)
>>  	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
>>  		return 6;
>>  	}
>> -	return 255; /* invalid */
>> +	return FILEID_INVALID; /* invalid */
>>  }
>
> I think you can drop the "/* invalid */" comment from there now as
> it is redundant with this change.
Okay, Thanks for review :-)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
