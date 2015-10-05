From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/3] BTRFS: support NFSv2 export
Date: Mon, 5 Oct 2015 10:32:46 -0400
Message-ID: <20151005143246.GW25218@ret.masoncoding.com>
References: <20150508001142.31129.7604.stgit@notabene.brown>
 <20150508001623.31129.91695.stgit@notabene.brown>
 <20150511081309.GI23255@suse.cz>
 <87r3lowpax.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=wAnkcxl0dSOj8kExb+thM1uQYSvhcdlyXgVoM8Gp24I=;
 b=Owz/crR8zl5EQtTmPkaDyPO0BDxX8JvN3OrFfIsUGaLk2EdMBRK7DdfUqrAF/QZwFGaP
 d7qRrL6dyOy7TZ3qRZjUk5+m/R8Fg21yo35BeS/zcJu5LUxkAI4752RI5Ko3wxSVeBBq
 cusYbfHF4gviSeiIbjJnKJaj4sPtF8vF7S0= 
Content-Disposition: inline
In-Reply-To: <87r3lowpax.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Neil Brown <neilb@suse.de>
Cc: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Sep 24, 2015 at 11:59:02AM +1000, Neil Brown wrote:
> David Sterba <dsterba@suse.cz> writes:
> 
> > On Fri, May 08, 2015 at 10:16:23AM +1000, NeilBrown wrote:
> >> The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
> >> that returned by encode_fh - it may be larger.
> >> 
> >> With NFSv2, the filehandle is fixed length, so it may appear longer
> >> than expected and be zero-padded.
> >> 
> >> So we must test that fh_len is at least some value, not exactly equal
> >> to it.
> >> 
> >> Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > Acked-by: David Sterba <dsterba@suse.cz>
> 
> Thanks.  However I just checked mainline and this still hasn't been
> applied.
> Should I resend it to someone?  Who?


Sorry Neil, I thought you were pushing these after it was ack'd.  I'll
put it in my pull this week.

-chris
