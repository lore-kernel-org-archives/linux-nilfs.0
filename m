From: Evert Mouw <post-yfx6isLFVcpeoWH0uzbU5w@public.gmane.org>
Subject: Re: time-shifting
Date: Mon, 08 Aug 2011 16:02:50 +0200
Message-ID: <4E3FEC8A.3000303@evert.net>
References: <4E3CEF72.1070303@evert.net>	<20110807.231959.212685724.ryusuke@osrg.net>	<4E3F0F16.7020200@evert.net> <20110808.212859.255403671.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110808.212859.255403671.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Op 2011-08-08 14:28, Ryusuke Konishi schreef:
> [...]
> I agree with this let-it-be approach. [...] If the
> previous checkpoint number is lost, we only have to track back to the
> last valid checkpoint younger than it and confirm that the inode
> contained in the checkpoint is alive with the same generation number.
>
> Regards,
> Ryusuke Konishi
Totally cool.

Nice that it would be possible and workable. Maybe the idea can be put 
in the todo list? I saw a one points on the todo list that might benefit 
from this approach:

- Time slider

The time slider for a single file could be implemented by using the 
proposed extra inode field "previous". (Another approach would be the 
one currently employed by the TimeBrowse program.)

Keep up the good work!

Regards, Evert

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
