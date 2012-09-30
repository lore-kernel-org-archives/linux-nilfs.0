From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 12:50:02 -0700
Message-ID: <20120930195002.GA30441@elie.Belkin>
References: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ckMilKUJqP41l6CNqg5qwQ7LiiV0u2N/WN31rrvEojk=;
        b=I5xzr/UGRRC59CKZ2js8odPHUfH3An51NL4EW6gH1UfCeWcFOSrazZxtHvv8H0Bh5l
         bJdKJgmPz28xgNZ6gorS32ccc3Kb4oDNwnF+9hNBVkigsAsqvAkcY3lBC1M+ajQ8llaJ
         wCvzabQ6m8etMR7RPLYyoaGOaqxTUPUXn0Psyv6yR1GqvKu6rxTCMqTw1tSjqqn3eFV5
         +XynRklDC29Kk7gbM8sltmj8q4ODnHomVUliBBOi//UcZeHyQu0n1HzwPcN5Xr+9Xgf0
         DctILveKzoIMjXTIQDt62H9Nq+EnLL+5F6ebzx8G/4keMEy6sI891wyVgTVJvQNpFsv8
         palg==
Content-Disposition: inline
In-Reply-To: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, stable@vger.kernel.org

Theodore Ts'o wrote:

> Since __block_page_mkwrite() only has three years,
> block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the

years = callers?
