From: Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 92/92] fs: rename i_ctime field to __i_ctime
Date: Thu, 6 Jul 2023 08:19:46 +0900
Message-ID: <a482ca9b-9621-7363-0233-1c0bec15aa6c__5259.08818687952$1688599280$gmane$org@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <20230705185812.579118-4-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688599209;
        bh=lKrue1sGsFTYklMQWRMbQ3My1e6nxD2ObDEGwR/VsF0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=HLxmQwiZ1LmjUMMnuuRPPSyg4M265uTgwaRQNcugB9qBZelv5caqUlnlZ5FOkyCBO
         LA9nfmoC3VcwDcNYXdLwyrAjpQ8qAvbq7SFByp4Q0d8VX6Iv9VyTpE94IU21bzQwq7
         AXFUzX0mVEu7h6lf94UAW2WWe3aMpfRBaJ0VbFwIq54AZXBu03Eb370uSlX/QYxLnb
         UXNpYhAvkUoamOq5NO810kR9phlIz2t2HqAG1QMsAKmqwo0IMtrDOTVHIlTnm36wsc
         mJPYsNRjIZdhZzmDYmS/04VlnpppU6zobkiJuxMYBpvIxpIIrXPcePBFRLkFK603MQ
         3zkknzFWV7lIQ==
Content-Language: en-US
In-Reply-To: <20230705185812.579118-4-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bwarrum-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, rituagar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org, linux_oss-kKOvUW9iAPtl57MIdRCFDg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.dionne-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, luisbg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, salah.triki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aivazian.tigran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, e

On 7/6/23 03:58, Jeff Layton wrote:
> Now that everything in-tree is converted to use the accessor functions,
> rename the i_ctime field in the inode to discourage direct access.
> 
> Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
Damien Le Moal
Western Digital Research

