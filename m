From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fs/buffer: Convert return type int to vm_fault_t
Date: Sat, 28 Jul 2018 09:04:03 -0600
Message-ID: <bf0ac658-582e-25a2-3a1d-1046d2c6228f@kernel.dk>
References: <20180728095043.GA24085@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IwRbCXQ2YaHI1aMdP9cps1U9m+EQOmzTZqBCJ1t7Mq0=;
        b=xaAfaGuogm4cGOqyDZ0PJUeqZdM4laDmXJB3jWtelOfXrVE/l+XC1+mYNvYAqsSsNB
         afP5D7nQxOwDzMD/GQzmk0iG3vGgr6w26AZ3I5LXiDPB//E/YKRC7PzHFBQEzbe5Qa7b
         5T5oRvD3/t5bYTjijPBndrbPqBZx4GcyGf4Oc7nrFflAobfcPw7KySu9FgQCuQAYE4e9
         w77sW7QvouRNE8eNmLgskXEuB6LAakU6T8kqHZsjkVrdrHEeZ3evhbGt6QmxMKRS+eMw
         Q6zpMVdY6M/1fWxiVVpIJtq7LPYNqYzoEGkZgCkYhkxADLYQBg8cCkbn8k2vz31gfFa+
         KqaA==
In-Reply-To: <20180728095043.GA24085@jordon-HP-15-Notebook-PC>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Souptick Joarder <jrdr.linux@gmail.com>, willy@infradead.org, viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp, darrick.wong@oracle.com, dchinner@redhat.com, pombredanne@nexb.com, ebiggers@google.com, gregkh@linuxfoundation.org, kemi.wang@intel.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com

On 7/28/18 3:50 AM, Souptick Joarder wrote:
>  out_unlock:
>  	unlock_page(page);
> +	ret = block_page_mkwrite_return(err);
>  	return ret;

	return block_page_mkwrite_return(err);

-- 
Jens Axboe

