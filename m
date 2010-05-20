From: Rich Pixley <rich.pixley-C65YXLrEp3M@public.gmane.org>
Subject: newbie question
Date: Thu, 20 May 2010 14:17:20 -0700
Message-ID: <4BF5A6E0.6040703@palm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Can nilfs "roll back" to a previous state of the file system?

For example, at some time = T(N), I have a file system in a known good 
state.  So I check point it before taking a risky action.  Then I take a 
risky action which leads me to the file system state at T(N+1).

Sometimes, my risky action will be fine and I'll want to continue on.  
Other times, my risky action will result in a polluted, useless 
collection of data which I would like to discard.

I understand that at time T(N+1) nilfs will allow me to create a 
checkpoint of T(N) which can be mounted read-only.  What I'm asking is 
if nilfs can discard the state at T(N+1) and "roll back" to the state at 
T(N) as though T(N+1) had never happened.

Can nilfs do this kind of "roll back"?

--rich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
