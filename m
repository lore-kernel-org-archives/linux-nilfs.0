From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] fs/buffer: Convert return type int to vm_fault_t
Date: Mon, 30 Jul 2018 10:19:56 +0530
Message-ID: <CAFqt6zY2756xkqQruBtfRun+fQNHRRF2dXJHOQYfrhW4g1-HFg@mail.gmail.com>
References: <20180728095043.GA24085@jordon-HP-15-Notebook-PC> <bf0ac658-582e-25a2-3a1d-1046d2c6228f@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=KAu0lnE+i48nXxt0r7z0sA8TcpvLp4I4zbDy5VBL3iw=;
        b=CRY/RlepBUjHt+a3sfpc5LWG0OCYd5018k4NQ0E9cEDTnsTkXFor68x9R4HhIsseLw
         Lr43RrB/vC35mVEWb+aZr4Mg9jK+EO8yf60XzttGe0gkz4cSflXPlLzCz0KRLLu6mp0o
         KJmxNCBiGv535PJFTemWkw4W7HHp1PpT+FS0ogxe2YslYqwVLGUQrYNni5t706HR7RCA
         Itdn74UEVXPRGWDM1YFzx0ZJ1DnliFncAHgsJ8O7zfhtIrjrcf1Ut6H85Mn8moe9owR6
         W27tw9LAcZ1IzC6G40qGoLBPyInPqxWodtt6PlxNCn1xiM92FltaHnjBumTZzWwDqcGj
         NSzg==
In-Reply-To: <bf0ac658-582e-25a2-3a1d-1046d2c6228f@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <dchinner@redhat.com>, Philippe Ombredanne <pombredanne@nexb.com>, Eric Biggers <ebiggers@google.com>, Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, Brajeswar Ghosh <brajeswar.linux@gmail.com>

On Sat, Jul 28, 2018 at 8:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 7/28/18 3:50 AM, Souptick Joarder wrote:
>>  out_unlock:
>>       unlock_page(page);
>> +     ret = block_page_mkwrite_return(err);
>>       return ret;
>
>         return block_page_mkwrite_return(err);
>
> --
> Jens Axboe
>

OK, I will post v2.
