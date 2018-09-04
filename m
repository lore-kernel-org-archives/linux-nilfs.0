From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Mon, 3 Sep 2018 19:13:55 -0700
Message-ID: <20180904021355.GA17153@bombadil.infradead.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
 <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
 <CAFqt6zZckYhLJuJr9TSw2KOZrt6qD25xDctuvbKfm0jyBoPycA@mail.gmail.com>
 <20180903172843.9bf312c738ce8a434dd9c242@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SwYoOGTJwPltXecgxvvFyCWLNUO+6wrT3VFzYnirq90=; b=FcUEBftWkg8yZudRxA/nXSTAi
        sq6mmY/0m8yA+p6ym4U3wJ24RQRzQhZBNpD2bBVAIYXkH8z7WHuQfNxgIOVxhzyqAW7asvEY258iJ
        uI0gFe8A0U9rXLY5pFt7xMiSZ4MBCprbTNnSkIA2mLirT9k8S91at0XgWSA5O3tjtNaP5JkkVc1np
        PkTP2PqX39TutDJod9r94SN5DeDXg94lDmm3uhWYYNvtyaW7WRN0YbUpqOQozTM4FgI7RrT7GCsTU
        gREakDcDgplU/NdrQbXfxVa4JsEyFstTnF/X97JmCL3gOU1Y+1poqauBDrrZf27OWwc5ASA5W8ubU
    
Content-Disposition: inline
In-Reply-To: <20180903172843.9bf312c738ce8a434dd9c242@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca, Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Biggers <ebiggers@google.com>, Philippe Ombredanne <pombredanne@nexb.com>, Andreas Gruenbacher <agruenba@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>

On Mon, Sep 03, 2018 at 05:28:43PM -0700, Andrew Morton wrote:
> > > I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> > > benefit we're going to get out of all this churn?

Hi Andrew,

The primary benefit is to help driver writers.  At the moment, there
is nothing to stop them returning -ENOMEM instead of VM_FAULT_NOMEM.
There were one or two examples of this in the tree, but I think they're
all gone now.

Secondarily, there are a number of places which translate between error
codes and vm_fault codes.  Those places are reduced as a result of these
patches, if not entirely eliminated yet.  There was some pretty extreme
cargo-culting of errno to vm_fault switch statements, particularly in
the DRM drivers.

There were also several places which were just ignoring the return value
of vm_insert_foo(), and as a result of this audit, those have been fixed.
Those errors are going to be rare, but can cause inappropriate decisions
to be made by the OOM killer.

Now that I think about it, vmf_insert_foo() should probably get marked
with __must_check to prevent those kinds of errors from being introduced
again.
