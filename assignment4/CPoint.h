
class CPoint
{
  public:
    int get_row() { return row; };
    int get_column() { return column; };
    void set_row(int _row) { row = _row; };
    void set_column(int _column) { column = _column; };
    void set_both(int _row, int _column) { row = _row;
                  column = _column; };
  private:
    int row, column;
};
