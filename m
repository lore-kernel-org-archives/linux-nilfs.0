From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v4 4/6] nilfs-utils: add suport for NILFS_IOCTL_SET_SUINFO
 ioctl
Date: Thu, 06 Feb 2014 00:43:01 +0100
Message-ID: <52F2CC85.3000004@gmx.net>
References: <cover.1391566347.git.andreas.rohner@gmx.net>	<cover.1391566347.git.andreas.rohner@gmx.net>	<6b62cd72448c48055cfab9017753349cb2cd7da9.1391566347.git.andreas.rohner@gmx.net> <20140206.042518.139122814.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140206.042518.139122814.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-02-05 20:25, Ryusuke Konishi wrote:
>>  /**
>> + * nilfs_set_suinfo - sets segment usage info
>> + * @nilfs: nilfs object
>> + * @sup: an array of nilfs_suinfo_update structs
>> + * @nsup: number of elements in sup
>> + *
>> + * Description: Takes an array of nilfs_suinfo_update structs and updates
>> + * segment usage info accordingly. Only the fields indicated by sup_flags
>> + * are updated.
>> + *
>> + * Return Value: On success, 0 is returned. On error, -1 is returned.
>> + */
>> +ssize_t nilfs_set_suinfo(struct nilfs *nilfs,
>> +			 struct nilfs_suinfo_update *sup, size_t nsup)
> 
> The type of return value of this function should be "int" because it
> doesn't return the count of obtained suinfo items.
> 
>> +{
>> +	struct nilfs_argv argv;
>> +
>> +	if (nilfs->n_iocfd < 0) {
>> +		errno = EBADF;
>> +		return -1;
>> +	}
>> +
>> +	argv.v_base = (unsigned long)sup;
>> +	argv.v_nmembs = nsup;
>> +	argv.v_size = sizeof(struct nilfs_suinfo_update);
>> +	argv.v_index = 0;
>> +	argv.v_flags = 0;
>> +	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv) < 0) {
>> +		if (errno == ENOTTY)
>> +			nilfs_opt_clear_set_suinfo(nilfs);
> 
> This invalidation should be done in utils or upper library.
> Simply return here as follows:
> 
>      return ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv);
> }

Thanks for your review. I have fixed everything you pointed out. Sorry
for all the missing stuff. I will wait with sending in a new version of
the patch set, until you finished your review. I suspect you will also
find some things in patch 5, since it is the crucial part of the
implementation.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
