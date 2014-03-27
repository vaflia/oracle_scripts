--сессии занимающие много места в undo
SELECT s.sid, s.serial#, s.program, s.username, t.xidusn undo_seg_num,
t.ubafil undo_block_addr_filenum,
t.ubablk undo_block_addr_block,
t.used_ublk,
round(t.used_ublk * 8 / 1024, 2) as used_undo_mb
FROM v$session s
left join v$transaction t on s.saddr = t.ses_addr
where t.xidusn > 0
order by used_undo_mb desc 